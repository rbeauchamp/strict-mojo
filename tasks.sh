#!/usr/bin/env bash
# Pixi task implementation for strict Mojo development workflow
# Handles build, run, test, and clean operations with zero-tolerance error checking
# Required because Mojo lacks a -Werror flag as of v25.4

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Function to run mojo with strict checking
run_mojo_strict() {
    local output
    local status
    
    # Use pixi run to ensure mojo is available
    output=$(pixi run mojo "$@" 2>&1)
    status=$?

    # Always display the output first
    echo "$output"

    # Fail on ANY diagnostic category that indicates potential issues
    if grep -E -q 'warning:|note:|deprecated:|DEPRECATED' <<< "$output"; then
        echo ""
        echo "❌ ERROR: Compilation aborted due to diagnostics treated as errors"
        echo ""
        
        # Count each type for detailed reporting
        warning_count=$(grep -c "warning:" <<< "$output" || true)
        note_count=$(grep -c "note:" <<< "$output" || true)
        deprecated_count=$(grep -ci "deprecated" <<< "$output" || true)
        
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
        echo "   Fix ALL issues above. Zero tolerance for warnings."
        exit 1
    fi

    # Also fail if the underlying mojo command failed
    if [ $status -ne 0 ]; then
        echo ""
        echo "❌ ERROR: Mojo command failed with exit code $status"
        exit $status
    fi
}

# Handle commands
command="$1"
shift  # Remove command from arguments

case "$command" in
    "build")
        echo "🎨 Formatting code..."
        pixi run mojo format --quiet .
        
        echo "🔨 Building with strict checks and thread sanitizer..."
        
        # Create build directory if it doesn't exist
        mkdir -p build
        
        # Check if no arguments provided - build everything
        if [ $# -eq 0 ]; then
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
            # Output specified, use it as-is - let user control compilation mode
            run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$@"
        else
            # No output specified, determine compilation mode based on file location
            source_file="$1"
            if [ -z "$source_file" ]; then
                echo "❌ ERROR: No source file provided"
                echo "Usage: ./tasks.sh build [source.mojo] [-o output]"
                echo "       ./tasks.sh build                    # Build entire project"
                exit 1
            fi
            
            # Determine if this is an executable or library module
            if [[ "$source_file" == bin/* ]]; then
                # Executable file - build as executable
                executable="build/$(basename "$source_file" .mojo)"
                echo "   Building executable: $source_file → $executable"
                run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$source_file" -o "$executable"
            elif [[ "$source_file" == src/* ]] || [[ "$source_file" == tests/* ]]; then
                # Library module - build as object file for validation
                object_file="build/$(basename "$source_file" .mojo).o"
                echo "   Building library module: $source_file → $object_file"
                run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$source_file" -o "$object_file"
            else
                # Unknown location - try as executable first, fallback to library
                executable="build/$(basename "$source_file" .mojo)"
                echo "   Building (auto-detect): $source_file → $executable"
                if ! run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$source_file" -o "$executable" 2>/dev/null; then
                    echo "   Executable build failed, trying as library module..."
                    object_file="build/$(basename "$source_file" .mojo).o"
                    run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread "$source_file" -o "$object_file"
                fi
            fi
        fi
        ;;
        
    "run")
        echo "🎨 Formatting code..."
        pixi run mojo format --quiet .
        
        echo "🚀 Building and running with thread sanitizer..."
        
        # Extract source file (first argument)
        source_file="$1"
        if [ -z "$source_file" ]; then
            echo "❌ ERROR: No source file provided"
            echo "Usage: ./tasks.sh run <source.mojo>"
            exit 1
        fi
        
        # Create build directory if it doesn't exist
        mkdir -p build
        
        # Generate executable name from source file in build directory
        executable="build/$(basename "$source_file" .mojo)"
        
        echo "   Building $source_file → $executable"
        run_mojo_strict build -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread "$source_file" -o "$executable"
        
        echo "   Executing ./$executable"
        "./$executable"
        ;;
        
    "test")
        echo "🎨 Formatting code..."
        pixi run mojo format --quiet .
        
        echo "🧪 Testing with strict compilation checks..."
        
        # If specific test file provided, validate it as a library module first
        if [[ "$1" == *.mojo ]]; then
            test_file="$1"
            echo "   Validating test file as library module: $test_file"
            
            # Validate documentation and syntax by building as object file
            run_mojo_strict build --emit object -g --diagnose-missing-doc-strings --validate-doc-strings "$test_file" -o /tmp/test_validation.o
            rm -f /tmp/test_validation.o
            
            echo "   Documentation validation passed"
            echo "   Running tests: $test_file"
            run_mojo_strict test -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread "$test_file"
        else
            # Run all tests (directory or pattern)
            echo "   Running test suite: $*"
            run_mojo_strict test -g --diagnose-missing-doc-strings --validate-doc-strings --sanitize thread "$@"
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