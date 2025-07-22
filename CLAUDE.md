# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with Mojo projects using the strict development template.

## Important: Shared Development Guidelines

This project may include additional development rules. Check for:

- `.cursor/rules/*.mdc` - Additional development requirements and practices
- Project-specific documentation in README.md
- Custom configuration in pixi.toml

## Strict Mojo Development Environment

This project uses a zero-tolerance approach to code quality, treating all warnings, notes, and deprecation notices as hard errors. The build system (`tasks.sh`) enforces complete documentation and strict type safety.

## Project Structure

```text
├── src/          # Library modules and packages
├── tests/        # Test modules
├── bin/          # Executable entry points
├── examples/     # Usage examples
├── benchmarks/   # Performance benchmarks
├── build/        # Build artifacts (auto-generated)
└── tasks.sh      # Build wrapper enforcing strict checks
```

## Essential Commands

### Always use pixi tasks - NEVER call mojo or ./tasks.sh directly

```bash
pixi run build                      # Build entire project
pixi run build <file.mojo>          # Build specific file
pixi run build <file.mojo> -o out   # Build with custom output
pixi run run <file.mojo>            # Build and execute
pixi run test                       # Run all tests
pixi run test <test.mojo>           # Run specific test
pixi run clean                      # Clean build artifacts
```

### Managing Dependencies

```bash
pixi install                        # Install after modifying pixi.toml
```

## Build System Architecture

### Compilation Pipeline

1. **pixi task** → Invokes task from pixi.toml
2. **Auto-formatting** → `mojo format --quiet` runs automatically
3. **tasks.sh wrapper** → Applies strict compilation flags:
   - `-g`: Debug symbols
   - `--diagnose-missing-doc-strings`: Enforce documentation
   - `--validate-doc-strings`: Validate doc format
   - `--max-notes-per-diagnostic 50`: Full error context
   - `--sanitize thread`: Thread safety checks
4. **Error interception** → ANY diagnostic treated as error

### Import Paths

When building files that import from project packages:

- Files in `tests/`, `examples/`, `benchmarks/` need `-I src` flag
- Currently must be added manually when using direct mojo commands
- Package imports use Python-style: `from package.module import function`

### Environment Variables (set in pixi.toml)

- `MOJO_PYTHON_INTEROP_WARNINGS="error"`: Python warnings as errors
- `MOJO_ENABLE_ASSERTIONS="1"`: Runtime assertions enabled
- `MOJO_ASSERT_ON_ERROR="1"`: Assert on errors
- `MOJO_DISABLE_OPTIMIZATIONS="0"`: Keep optimizations

## Mojo Code Requirements

### 1. Mandatory Function Documentation

```mojo
fn function_name(param1: Type1, param2: Type2) -> ReturnType:
    """Brief description of function purpose.
    
    Args:
        param1: Description of first parameter.
        param2: Description of second parameter.
        
    Returns:
        Description of return value.
        
    Raises:
        ErrorType: When this error occurs (if applicable).
    """
    # Implementation
```

### 2. Method Documentation (for structs)

```mojo
struct MyStruct:
    """Brief description of the struct.
    
    Longer description if needed, explaining purpose
    and usage patterns.
    """
    
    fn __init__(out self: MyStruct):
        """Initialize a new instance.
        
        Note: Use 'out self' for constructors.
        """
        pass
    
    fn method(mut self: MyStruct):
        """Method that modifies state.
        
        Note: Use 'mut self' for mutating methods.
        """
        pass
```

### 3. Handling Unused Variables

```mojo
# ✅ Correct - underscore for intentionally unused
var _ = function_that_returns_value()

# ❌ Wrong - will fail strict compilation
var unused = function_that_returns_value()

# ✅ Correct - underscore in loops
for _ in range(10):
    do_something()
```

### 4. Modern Mojo Syntax

```mojo
# Method receivers (self parameters):
fn __init__(out self: Type)      # Constructors
fn method(mut self: Type)        # Mutating methods  
fn method(self: Type)            # Read-only methods
fn __del__(owned self: Type)     # Destructors

# Avoid deprecated syntax:
# ❌ fn method(inout self: Type)  # Use 'mut self' instead
```

## Common Compilation Errors

| Error | Solution |
|-------|----------|
| "missing a doc string" | Add complete docstring with Args/Returns sections |
| "assignment was never used" | Change to `var _ =` or remove variable |
| "cannot read from discard pattern '_'" | Use named variable if you need the value |
| "'self' argument must have type" | Check method receiver syntax |
| "unknown argument in doc string" | Remove extra blank lines in docstring |

## Python Interoperability

```mojo
# 1. Add to pixi.toml [pypi-dependencies]
# 2. Run: pixi install
# 3. Import in Mojo:
from python import Python
fn use_numpy() raises:
    var np = Python.import_module("numpy")
    var array = np.array([1, 2, 3])
```

## Testing Best Practices

```mojo
from testing import assert_equal, assert_true, assert_false

fn test_feature():
    """Test description.
    
    Tests specific behavior or edge case.
    """
    # Arrange
    var input = prepare_test_data()
    
    # Act
    var result = function_under_test(input)
    
    # Assert
    assert_equal(result, expected_value)
```

## Project Organization Guidelines

### Package Structure (src/)

- Use `__init__.mojo` to define package exports
- Keep related functionality together
- Follow Python-style naming: lowercase with underscores

### Test Files (tests/)

- Prefix with `test_` for test files
- Mirror source structure: `src/module.mojo` → `tests/test_module.mojo`
- Include both positive and negative test cases

### Executables (bin/)

- Contain only entry point and CLI logic
- Delegate business logic to library modules
- Always include a `main()` function

### Examples (examples/)

- Demonstrate real-world usage patterns
- Keep simple and focused
- Import from project packages

### Benchmarks (benchmarks/)

- Use consistent timing methodology
- Compare different implementations
- Document performance characteristics

## Development Workflow

1. **Before committing**: Run `pixi run build` to ensure no errors
2. **Auto-formatting**: Applied automatically by build commands
3. **Documentation**: Required for ALL public functions and structs
4. **Error handling**: Use proper error types and document in docstrings

## Useful Resources

- Mojo documentation: <https://docs.modular.com/mojo>
- LLM-friendly docs: <https://docs.modular.com/llms-mojo.txt>
- Language reference: <https://docs.modular.com/mojo/manual>

## Notes for AI Assistants

When working on this codebase:

1. Always use pixi commands, never invoke mojo directly
2. Ensure all code includes complete documentation
3. Use underscore for intentionally unused variables
4. Follow the established project structure
5. When imports fail, suggest adding `-I src` to the build command
6. Treat all compiler diagnostics as errors that must be fixed

This strict approach ensures high code quality and maintainability across the entire project.
