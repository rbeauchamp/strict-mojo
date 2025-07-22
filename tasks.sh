#!/usr/bin/env bash
# Pixi task implementation for strict Mojo development workflow
# Handles build, run, test, and clean operations with zero-tolerance error checking
# Required because Mojo lacks a -Werror flag as of v25.4

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Common Mojo build flags for strict checking
MOJO_BUILD_FLAGS="-g --diagnose-missing-doc-strings --validate-doc-strings --max-notes-per-diagnostic 50 --sanitize thread"

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
                    run_mojo_strict build $MOJO_BUILD_FLAGS -I src "$executable_file" -o "$executable"
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
                    run_mojo_strict build --emit object $MOJO_BUILD_FLAGS "$library_file" -o "$object_file"
                fi
            done
        fi
        
        # Build all examples
        if [ -d "examples" ]; then
            echo "   📚 Building examples:"
            for example_file in examples/*.mojo; do
                if [ -f "$example_file" ]; then
                    executable="build/$(basename "$example_file" .mojo)"
                    echo "      $example_file → $executable"
                    run_mojo_strict build $MOJO_BUILD_FLAGS -I src "$example_file" -o "$executable"
                fi
            done
        fi
        
        # Build all benchmarks
        if [ -d "benchmarks" ]; then
            echo "   ⚡ Building benchmarks:"
            for benchmark_file in benchmarks/*.mojo; do
                if [ -f "$benchmark_file" ]; then
                    executable="build/$(basename "$benchmark_file" .mojo)"
                    echo "      $benchmark_file → $executable"
                    run_mojo_strict build $MOJO_BUILD_FLAGS -I src "$benchmark_file" -o "$executable"
                fi
            done
        fi
        
        # Validate all test modules
        if [ -d "tests" ]; then
            echo "   🧪 Validating test modules:"
            for test_file in tests/*.mojo; do
                if [ -f "$test_file" ]; then
                    object_file="build/$(basename "$test_file" .mojo).o"
                    echo "      $test_file → $object_file"
                    run_mojo_strict build --emit object $MOJO_BUILD_FLAGS -I src "$test_file" -o "$object_file"
                fi
            done
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
            run_mojo_strict build $MOJO_BUILD_FLAGS -I src "$source_file" -o "$executable"
        else
            run_mojo_strict build $MOJO_BUILD_FLAGS "$source_file" -o "$executable"
        fi
        
        echo "   Executing ./$executable"
        "./$executable" "$@"
        ;;
        
    "test")
        # If specific test file provided, run it
        if [ $# -gt 0 ] && [[ "$1" == *.mojo ]]; then
            test_file="$1"
            
            # Format only the specific test file
            format_files "$test_file"
            
            echo "🧪 Testing with strict compilation checks..."
            echo "   Running tests: $test_file"
            run_mojo_strict test $MOJO_BUILD_FLAGS -I src "$test_file"
        else
            # Run all tests (directory or pattern) - format all test files
            format_files  # Format all files when running full test suite
            
            echo "🧪 Testing with strict compilation checks..."
            # Run all tests (directory or pattern)
            echo "   Running test suite: $*"
            run_mojo_strict test $MOJO_BUILD_FLAGS -I src "$@"
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
        echo "  build  - Compile the entire project with strict checks"
        echo "  run    - Build and execute a specific file with thread sanitizer"
        echo "  test   - Run all tests, or a specific test file"
        echo "  clean  - Remove all build artifacts, executables, and pixi environments"
        echo "           Use 'clean --cache' to also clean pixi cache"
        exit 1
        ;;
esac

echo "✅ Complete"