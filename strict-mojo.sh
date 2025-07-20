#!/usr/bin/env bash
# Strict Mojo compilation wrapper
# Required because Mojo lacks a -Werror flag as of v25.4
# Makes ALL diagnostics (warnings, notes, deprecations) into hard errors

set -euo pipefail  # Exit on error, undefined vars, pipe failures

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

exit 0