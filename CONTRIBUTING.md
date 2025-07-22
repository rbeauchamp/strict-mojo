# Contributing to Strict Mojo Template

Thank you for considering contributing to the Strict Mojo Template! This guide will help you understand our development process and standards.

## Development Standards

This project maintains the **highest possible code quality standards**:

- 🚨 **Zero warnings tolerance** - All warnings are treated as errors
- 📝 **Mandatory documentation** - Every function must have proper docstrings
- 🎨 **Automatic formatting** - Code is automatically formatted before builds
- 🔍 **Strict compilation** - Maximum diagnostics and validation enabled
- 🧪 **Comprehensive testing** - All code must have corresponding tests

## Getting Started

### Prerequisites

1. **Mojo SDK** - Latest version from [Modular](https://docs.modular.com/mojo/)
2. **Pixi** - Package manager for the project

   ```bash
   curl -fsSL https://pixi.sh/install.sh | bash
   ```

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

## Development Workflow

### 1. Code Standards

All code must follow these strict standards:

#### Documentation Requirements

Every function must have a complete docstring:

```mojo
fn calculate_sum(a: Int, b: Int) -> Int:
    """Calculate the sum of two integers.
    
    Args:
        a: First integer operand.
        b: Second integer operand.
        
    Returns:
        The sum of a and b.
        
    Examples:
        >>> calculate_sum(5, 3)
        8
    """
    return a + b
```

#### No Warnings Policy

- Zero warnings are allowed in compilation
- All potential issues must be fixed, not suppressed
- Use `_` for intentionally unused variables

#### Testing Requirements

- Every public function must have tests
- Tests must cover normal cases, edge cases, and error conditions
- Use descriptive test names that explain what is being tested

### 2. Development Commands

Use these commands during development:

```bash
# Format code (done automatically before builds)
pixi run format

# Check formatting without making changes
pixi run format-check

# Build the entire project
pixi run build

# Build a specific file
pixi run build src/package_name/core.mojo

# Run tests
pixi run test

# Run a specific test file
pixi run test test/test_core.mojo

# Clean build artifacts
pixi run clean
```

### 3. Adding New Features

When adding new functionality:

1. **Write tests first** (TDD approach recommended)
2. **Add documentation** for all public APIs
3. **Update examples** if the change affects usage
4. **Verify strict compilation** with all checks enabled

### 4. Project Structure

Follow this structure for new files:

```text
strict-mojo/
├── src/package_name/          # Library code
├── bin/                       # Executable files
├── test/                      # Test files (test_*.mojo)
├── examples/                  # Usage examples
├── benchmarks/                # Performance benchmarks
├── docs/                      # Documentation
└── .github/                   # GitHub templates
```

## Pull Request Process

### Before Submitting

1. **Run all checks locally**:

   ```bash
   pixi run format-check  # Verify formatting
   pixi run build         # Verify compilation
   pixi run test          # Verify all tests pass
   ```

2. **Verify examples still work**:

   ```bash
   pixi run build examples/basic_usage.mojo -o build/example
   ./build/example
   ```

3. **Check your changes**:
   - [ ] All new code has documentation
   - [ ] All new code has tests
   - [ ] No warnings or notes in compilation output
   - [ ] Examples are updated if needed
   - [ ] Commit messages are descriptive

### Pull Request Guidelines

1. **Create a focused PR** - One feature/fix per PR
2. **Use descriptive titles** - Clearly explain what the PR does
3. **Fill out the PR template** - Provide all requested information
4. **Link related issues** - Reference any relevant issue numbers
5. **Request review** - Tag maintainers for review

### Review Process

All PRs must:

- [ ] Pass all automated checks
- [ ] Have clean, documented code
- [ ] Include appropriate tests
- [ ] Follow project conventions
- [ ] Be approved by a maintainer

## Code Review Standards

When reviewing code, we check for:

### Technical Quality

- Correctness and efficiency
- Proper error handling
- Thread safety where applicable
- Performance implications

### Documentation

- Complete and accurate docstrings
- Clear parameter and return descriptions
- Useful examples where appropriate
- Updated README if needed

### Testing

- Comprehensive test coverage
- Edge case handling
- Error condition testing
- Performance considerations

## Issue Reporting

### Bug Reports

Use the bug report template and include:

- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment information
- Any relevant error messages

### Feature Requests

Use the feature request template and include:

- Clear description of the proposed feature
- Use case and problem it solves
- Proposed implementation approach
- Alternatives considered

## Community Guidelines

### Be Respectful

- Use inclusive language
- Respect different viewpoints
- Provide constructive feedback
- Help newcomers learn

### Be Collaborative

- Share knowledge and resources
- Review others' contributions
- Participate in discussions
- Help maintain project quality

## Questions?

- **General questions**: Start a [discussion](https://github.com/yourusername/strict-mojo/discussions)
- **Bug reports**: Open an [issue](https://github.com/yourusername/strict-mojo/issues)
- **Feature requests**: Open an [issue](https://github.com/yourusername/strict-mojo/issues)

## Recognition

Contributors who help improve this template will be recognized in the README and release notes. We appreciate all forms of contribution, from code to documentation to issue reports!

---

Thank you for contributing to the Strict Mojo Template! Your help makes the Mojo community stronger. 🔥
