#!/usr/bin/env bash
# Pixi task implementation for strict Mojo development workflow
# Handles build, run, test, and clean operations with zero-tolerance error checking
# Required because Mojo lacks a -Werror flag as of v25.4

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Function to run mojo with strict checking
run_mojo_strict() {
    local output
    local status
    
    # Temporarily disable strict error handling for command capture
    set +e
    output=$(pixi run mojo "$@" 2>&1)
    status=$?
    set -e

    # Always display the output first
    echo "$output"

    # Fail on ANY diagnostic category that indicates potential issues
    if grep -E -q 'error:|warning:|note:|deprecated:|DEPRECATED' <<< "$output"; then
        echo ""
        echo "❌ ERROR: Compilation aborted due to diagnostics treated as errors"
        echo ""
        
        # Count each type for detailed reporting
        error_count=$(grep -c "error:" <<< "$output" || true)
        warning_count=$(grep -c "warning:" <<< "$output" || true)
        note_count=$(grep -c "note:" <<< "$output" || true)
        deprecated_count=$(grep -ci "deprecated" <<< "$output" || true)
        
        if [ $error_count -gt 0 ]; then
            echo "   - $error_count error(s) found"
        fi
        if [ $warning_count -gt 0 ]; then
            echo "   - $warning_count warning(s) found"
        fi
        if [ $note_count -gt 0 ]; then
            echo "   - $note_count note(s) found"
        fi
        if [ $deprecated_count -gt 0 ]; then
            echo "   - $deprecated_count deprecated usage(s) found"
        fi
        
        echo ""
        echo "   Fix ALL issues above. Zero tolerance for errors, warnings, and notes."
        exit 1
    fi

    # Also fail if the underlying mojo command failed
    if [ $status -ne 0 ]; then
        echo ""
        echo "❌ ERROR: Mojo command failed with exit code $status"
        exit $status
    fi
}

# Function to format specific files
format_files() {
    local files=("$@")
    if [ ${#files[@]} -eq 0 ]; then
        echo "🎨 Formatting all code..."
        pixi run mojo format --quiet .
    else
        echo "🎨 Formatting specified files..."
        for file in "${files[@]}"; do
            if [ -f "$file" ]; then
                echo "   Formatting: $file"
                pixi run mojo format --quiet "$file"
            fi
        done
    fi
}

# Handle commands
command="$1"
shift  # Remove command from arguments

case "$command" in
    "build")
        # Create build directory if it doesn't exist
        mkdir -p build
        
        # Check if no arguments provided - build everything
        if [ $# -eq 0 ]; then
            format_files  # Format all files when building entire project
            echo "🔨 Building with strict checks and thread sanitizer..."
            echo "   Building entire project..."
            
            # Build all executables from bin/
            if [ -d "bin" ]; then
                echo "   🔨 Building executables:"
                for executable_file in bin/*.mojo; do
                    if [ -f "$executable_file" ]; then
                        executable="build/$(basename "$executable_file" .mojo)"
                        echo "      $executable_file → $executable"
                        run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$executable_file" -o "$executable"
                    fi
                done
            fi
            
            # Validate all library modules from src/
            if [ -d "src" ]; then
                echo "   🔧 Validating library modules:"
                find src -name "*.mojo" -type f | while read -r library_file; do
                    # Skip __init__.mojo files as they contain relative imports
                    if [[ "$(basename "$library_file")" == "__init__.mojo" ]]; then
                        echo "      $library_file → skipped (package init file)"
                        continue
                    fi
                    
                    if [ -f "$library_file" ]; then
                        object_file="build/$(basename "$library_file" .mojo).o"
                        echo "      $library_file → $object_file"
                        run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$library_file" -o "$object_file"
                    fi
                done
            fi
            
        # Check if output flag is provided, if not, use build/ directory
        elif [[ "$*" == *"-o "* ]]; then
            # Extract source file for formatting (first non-option argument)
            source_file=""
            for arg in "$@"; do
                if [[ "$arg" != -* ]] && [[ "$arg" == *.mojo ]]; then
                    source_file="$arg"
                    break
                fi
            done
            
            if [ -n "$source_file" ]; then
                format_files "$source_file"
            else
                format_files  # Format all if we can't determine source file
            fi
            
            echo "🔨 Building with strict checks and thread sanitizer..."
            # Output specified, use it as-is - let user control compilation mode
            # Add -I src if source file is not in src/
            if [ -n "$source_file" ] && [[ "$source_file" != src/* ]]; then
                run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread -I src "$@"
            else
                run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$@"
            fi
        else
            # No output specified, determine compilation mode based on file location
            source_file="$1"
            if [ -z "$source_file" ]; then
                echo "❌ ERROR: No source file provided"
                echo "Usage: ./tasks.sh build [source.mojo] [-o output]"
                echo "       ./tasks.sh build                    # Build entire project"
                exit 1
            fi
            
            # Format only the specific file being built
            format_files "$source_file"
            echo "🔨 Building with strict checks and thread sanitizer..."
            
            # Determine if this is an executable or library module
            if [[ "$source_file" == bin/* ]]; then
                # Executable file - build as executable
                executable="build/$(basename "$source_file" .mojo)"
                echo "   Building executable: $source_file → $executable"
                run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread -I src "$source_file" -o "$executable"
            elif [[ "$source_file" == src/* ]]; then
                # Library module - build as object file for validation (no -I src needed)
                object_file="build/$(basename "$source_file" .mojo).o"
                echo "   Building library module: $source_file → $object_file"
                run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$source_file" -o "$object_file"
            elif [[ "$source_file" == tests/* ]] || [[ "$source_file" == examples/* ]] || [[ "$source_file" == benchmarks/* ]]; then
                # Test/example/benchmark files need -I src for imports
                if [[ "$source_file" == tests/* ]]; then
                    # Tests are library modules
                    object_file="build/$(basename "$source_file" .mojo).o"
                    echo "   Building test module: $source_file → $object_file"
                    run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread -I src "$source_file" -o "$object_file"
                else
                    # Examples and benchmarks are executables
                    executable="build/$(basename "$source_file" .mojo)"
                    echo "   Building $([[ "$source_file" == examples/* ]] && echo "example" || echo "benchmark"): $source_file → $executable"
                    run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread -I src "$source_file" -o "$executable"
                fi
            else
                # Unknown location - try as executable with -I src
                executable="build/$(basename "$source_file" .mojo)"
                echo "   Building (auto-detect): $source_file → $executable"
                if ! run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread -I src "$source_file" -o "$executable" 2>/dev/null; then
                    echo "   Executable build failed, trying as library module..."
                    object_file="build/$(basename "$source_file" .mojo).o"
                    run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread -I src "$source_file" -o "$object_file"
                fi
            fi
        fi
        ;;
        
    "run")
        # Extract source file (first argument)
        source_file="$1"
        if [ -z "$source_file" ]; then
            echo "❌ ERROR: No source file provided"
            echo "Usage: ./tasks.sh run <source.mojo> [args...]"
            exit 1
        fi
        shift  # Remove source file from arguments
        
        # Format only the specific file being run
        format_files "$source_file"
        
        echo "🚀 Building and running with thread sanitizer..."
        
        # Create build directory if it doesn't exist
        mkdir -p build
        
        # Generate executable name from source file in build directory
        executable="build/$(basename "$source_file" .mojo)"
        
        echo "   Building $source_file → $executable"
        # Add -I src for files that might need to import from src/
        if [[ "$source_file" != src/* ]]; then
            run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread -I src "$source_file" -o "$executable"
        else
            run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread "$source_file" -o "$executable"
        fi
        
        echo "   Executing ./$executable"
        "./$executable" "$@"
        ;;
        
    "test")
        # If specific test file provided, validate it as a library module first
        if [ $# -gt 0 ] && [[ "$1" == *.mojo ]]; then
            test_file="$1"
            
            # Format only the specific test file
            format_files "$test_file"
            
            echo "🧪 Testing with strict compilation checks..."
            echo "   Validating test file as library module: $test_file"
            
            # Validate documentation and syntax by building as object file
            run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings -I src "$test_file" -o /tmp/test_validation.o
            rm -f /tmp/test_validation.o
            
            echo "   Documentation validation passed"
            echo "   Running tests: $test_file"
            run_mojo_strict test -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread -I src "$test_file"
        else
            # Run all tests (directory or pattern) - format all test files
            format_files  # Format all files when running full test suite
            
            echo "🧪 Testing with strict compilation checks..."
            # Run all tests (directory or pattern)
            echo "   Running test suite: $*"
            run_mojo_strict test -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread -I src "$@"
        fi
        ;;
        
    "clean")
        echo "🧹 Cleaning build artifacts..."
        
        # Clean pixi environments and .pixi folder
        echo "   Cleaning pixi environments..."
        pixi clean
        
        # Remove build directory
        if [ -d "build" ]; then
            rm -rf build/
            echo "   Removed build/ directory"
        fi
        
        # Remove other build artifacts
        if [ -d "packages" ]; then
            rm -rf packages/
            echo "   Removed packages/ directory"
        fi
        
        # Remove debug symbols
        if ls *.dSYM/ 1> /dev/null 2>&1; then
            rm -rf *.dSYM/
            echo "   Removed debug symbol directories"
        fi
        
        # Remove common executable names from root directory
        for binary in main test app benchmark; do
            if [ -f "$binary" ]; then
                rm -f "$binary"
                echo "   Removed $binary executable"
            fi
        done
        
        # Optional: Clean pixi cache (pass --cache flag to enable)
        if [[ "$*" == *"--cache"* ]]; then
            echo "   Cleaning pixi cache..."
            pixi clean cache -y
        fi
        ;;
        
    *)
        echo "❌ ERROR: Unknown command '$command'"
        echo "Usage: ./tasks.sh {build|run|test|clean} [arguments...]"
        echo ""
        echo "Commands:"
        echo "  build  - Compile with strict checks and thread sanitizer"
        echo "           Use 'build' alone to build entire project"
        echo "           Use 'build <file.mojo>' to build specific file"
        echo "  run    - Build and execute with thread sanitizer"
        echo "  test   - Run tests with strict checks and thread sanitizer"
        echo "  clean  - Remove all build artifacts, executables, and pixi environments"
        echo "           Use 'clean --cache' to also clean pixi cache"
        exit 1
        ;;
esac

echo "✅ Complete"