# Contributing to Strict Mojo Template

Thank you for contributing to the Strict Mojo Template! This guide is for contributors who want to improve the template itself.

## About This Template

This is a GitHub template repository that provides a strict, zero-warnings Mojo project structure. Your contributions help the entire Mojo community build better software.

## Development Standards

This template enforces the **highest code quality standards**:

- 🚨 **Zero warnings tolerance** - All warnings are treated as errors
- 📝 **Mandatory documentation** - Every function must have proper docstrings
- 🎨 **Automatic formatting** - Code is automatically formatted before builds
- 🔍 **Strict compilation** - Maximum diagnostics and validation enabled

## Getting Started

### Prerequisites

1. **Mojo SDK** - Latest version from [Modular](https://docs.modular.com/mojo/)
2. **Pixi** - Package manager (install via `curl -fsSL https://pixi.sh/install.sh | bash`)
3. **Git** - Version control

### Setup

1. **Fork and clone** the repository:

   ```bash
   git clone https://github.com/yourusername/strict-mojo.git
   cd strict-mojo
   ```

2. **Install dependencies**:

   ```bash
   pixi install
   ```

3. **Verify setup**:

   ```bash
   pixi run build
   pixi run test
   ```

## Areas for Contribution

### 1. Template Infrastructure

- Improve `tasks.sh` build wrapper
- Enhance error detection patterns
- Add new pixi tasks
- Optimize build performance

### 2. Example Code

- Improve example modules in `src/package_name/`
- Add more comprehensive examples
- Enhance benchmarks
- Create better test patterns

### 3. Documentation

- Improve README.md
- Enhance AI assistant files (CLAUDE.md, GEMINI.md)
- Add more code examples
- Fix typos and clarify instructions

### 4. Developer Experience

- Add new GitHub Actions workflows
- Create issue/PR templates
- Improve error messages
- Add development tools

## Development Workflow

### Working with the Template

1. **Understand the structure**:
   - `tasks.sh` - Core build wrapper enforcing strict checks
   - `pixi.toml` - Project configuration and tasks
   - `src/package_name/` - Example package structure
   - `tests/` - Example test structure

2. **Test your changes**:

   ```bash
   # Build everything
   pixi run build
   
   # Run tests
   pixi run test
   
   # Test specific components
   pixi run build src/package_name/core.mojo
   pixi run run examples/basic_usage.mojo
   ```

3. **Verify strict mode works**:
   - Introduce a warning intentionally
   - Confirm build fails
   - Fix the warning

### Code Standards

All code must follow Mojo best practices:

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

Use modern Mojo syntax:

- `out self` for constructors
- `mut self` for mutating methods
- `_` for unused variables

## Submitting Changes

### Before Creating a PR

1. **Ensure all checks pass**:

   ```bash
   pixi run build
   pixi run test
   ```

2. **Test the template workflow**:
   - Create a new project from your fork
   - Verify it builds correctly
   - Ensure strict mode catches warnings

3. **Update documentation**:
   - Update README if needed
   - Update AI assistant files if behavior changes
   - Ensure examples still work

### Pull Request Guidelines

1. **One feature per PR** - Keep changes focused
2. **Clear description** - Explain what and why
3. **Show it working** - Include example output
4. **Update tests** - Add tests for new features
5. **Document changes** - Update relevant docs

### What Makes a Good PR

- ✅ Improves developer experience
- ✅ Maintains zero-warnings philosophy  
- ✅ Includes tests and documentation
- ✅ Works across different Mojo versions
- ✅ Follows existing code style

## Testing the Template

When modifying the template, test that it works correctly:

```bash
# Create a test project
cp -r . /tmp/test-strict-mojo
cd /tmp/test-strict-mojo

# Remove template-specific files
rm -rf .git

# Initialize as new project
git init
pixi install
pixi run build
pixi run test
```

## Common Contributions

### Adding a New Pixi Task

1. Edit `pixi.toml` to add the task
2. Update README.md with usage
3. Add example in CONTRIBUTING.md
4. Test the task thoroughly

### Improving Error Detection

1. Edit `tasks.sh` to catch new patterns
2. Add test case that triggers the error
3. Verify it fails appropriately
4. Document the new check

### Enhancing Examples

1. Keep examples simple and focused
2. Ensure they demonstrate best practices
3. Add comprehensive documentation
4. Make them actually useful

## Questions and Support

- **Questions**: Open a [discussion](https://github.com/rdancer/strict-mojo/discussions)
- **Bugs**: Open an [issue](https://github.com/rdancer/strict-mojo/issues)
- **Ideas**: Share in discussions first

## Recognition

Contributors are recognized in:

- README.md contributors section
- Release notes
- GitHub contributors page

Thank you for making the Strict Mojo Template better! 🔥
