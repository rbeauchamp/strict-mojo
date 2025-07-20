# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Important: Shared Development Guidelines

This project uses consistent development rules across all AI assistants. Please also refer to:

- `.cursor/rules/mojo.mdc` - Strict Mojo development requirements
- `.cursor/rules/development.mdc` - General development practices  
- `.cursor/rules/general_behavior_rules.mdc` - Core coding principles

These files contain authoritative guidance that applies to all AI assistants working on this codebase.

## Project Overview

This is a strict Mojo template that enforces zero-tolerance for warnings and requires complete documentation for all code. The architecture consists of a build wrapper (`strict-mojo.sh`) that intercepts all Mojo compiler output and treats any diagnostic (warnings, notes, deprecations) as a hard error.

## Commands

### Build Commands

```bash
pixi run build <file.mojo> -o <output>  # Compile with all strict checks
pixi run run <file.mojo>                # Run directly with strict checks
pixi run test                           # Run tests with strict checks
```

### Python Dependencies

```bash
pixi install                            # Install after modifying pixi.toml
```

**NEVER** call `mojo` or `./strict-mojo.sh` directly - always use pixi tasks.

## Architecture

### Build Pipeline

1. `pixi run build/run/test` invokes the task defined in `pixi.toml`
2. Tasks first run `mojo format --quiet .` to auto-format all code
3. Then invoke `strict-mojo.sh` with compiler flags:
   - `-g`: Debug symbols
   - `--diagnose-missing-doc-strings`: Require documentation
   - `--validate-doc-strings`: Validate doc format
   - `--max-notes-per-diagnostic 50`: Full error context
   - `--sanitize thread`: Thread safety checks

### Strict Wrapper (`strict-mojo.sh`)

- Captures all Mojo compiler output
- Searches for `warning:`, `note:`, `deprecated:`, `DEPRECATED`
- ANY match causes build failure with detailed counts
- No way to suppress warnings - all issues must be fixed

### Environment Configuration

Set via `pixi.toml` `[activation.env]`:

- `MOJO_PYTHON_INTEROP_WARNINGS="error"`: Python interop warnings → errors
- `MOJO_ENABLE_ASSERTIONS="1"`: Runtime assertions always enabled
- `MOJO_ASSERT_ON_ERROR="1"`: Assert on errors
- `MOJO_DISABLE_OPTIMIZATIONS="0"`: Keep optimizations

## Required Function Documentation

Every function MUST have a docstring with proper formatting:

```mojo
fn example_function(x: Int, y: String) -> Bool:
    """Brief description of what the function does.
    
    Args:
        x: Description of parameter x.
        y: Description of parameter y.
        
    Returns:
        Description of return value.
    """
    # Implementation
```

## Handling Unused Variables

If a variable is intentionally unused, use underscore:

```mojo
# ✅ Correct
var _ = some_function()  # Return value intentionally ignored

# ❌ Wrong - will fail compilation
var unused = some_function()
```

## Working with Python Dependencies

1. Add dependencies to `pixi.toml` under `[pypi-dependencies]`
2. Run `pixi install` after adding
3. Import in Mojo using: `var module = Python.import_module("module_name")`

## Mojo Code Requirements

### Function Template

```mojo
fn function_name(param: Type) -> ReturnType:
    """Brief description.
    
    Args:
        param: Parameter description.
        
    Returns:
        Return value description.
    """
    # Implementation
```

### Unused Variables

```mojo
var _ = some_function()  # ✅ Use underscore for intentionally unused
var unused = value       # ❌ Will fail compilation
```

### Python Interop

```mojo
var np = Python.import_module("numpy")  # After adding to pixi.toml
```

## Common Errors and Solutions

| Error | Solution |
|-------|----------|
| "missing a doc string" | Add complete docstring with Args/Returns |
| "assignment was never used" | Use `var _ =` or remove the variable |
| "unknown argument in doc string" | Fix formatting - remove extra blank lines |
| Thread sanitizer warnings | Fix race conditions in concurrent code |

## Development Philosophy

The cursor rules in `.cursor/rules/` contain comprehensive guidance on:

- Test-Driven Development (TDD) practices
- Code organization and refactoring principles
- Security best practices
- Git hygiene and version control

Please review these files for detailed development workflows and patterns.

## LLM-friendly Documentation

- Docs index: <https://docs.modular.com/llms.txt>
- Mojo API docs: <https://docs.modular.com/llms-mojo.txt>
- Python API docs: <https://docs.modular.com/llms-python.txt>
- Comprehensive docs: <https://docs.modular.com/llms-full.txt>

## Additional Guidelines

For comprehensive coding standards and practices, refer to `.cursor/rules/general_behavior_rules.mdc` which includes:

- Code investigation and validation practices
- Error handling and logging requirements
- Documentation standards
- Environment management

All guidelines in the cursor rules files apply when working with Claude Code.
