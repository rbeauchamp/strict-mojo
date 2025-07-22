# Strict Mojo Template 🔥

[![License](https://img.shields.io/badge/license-Unlicense-blue.svg)](LICENSE)
[![Mojo](https://img.shields.io/badge/Mojo-25.4-orange.svg)](https://docs.modular.com/mojo/)

A comprehensive GitHub template for creating professional Mojo projects with **strict compilation standards**, **zero-tolerance error policies**, and **Python packaging best practices**.

## 🌟 Features

- 🚨 **Zero Warnings Tolerance** - All warnings treated as compilation errors
- 📝 **Mandatory Documentation** - Every function requires proper docstrings  
- 🎨 **Auto-formatting** - Code automatically formatted before every build
- 🔍 **Maximum Diagnostics** - Detailed error reporting with full context
- 🧪 **Comprehensive Testing** - Built-in test structure with examples
- 🏗️ **Standard Project Layout** - Follows Python packaging conventions adapted for Mojo
- ⚡ **Performance Benchmarking** - Included benchmark framework
- 🐛 **Runtime Safety** - Thread sanitizer and debug assertions enabled
- 📦 **Modern Package Management** - Uses Pixi for dependency management
- 🤖 **AI Assistant Ready** - Pre-configured for Claude and Gemini AI assistants

## 🚀 Quick Start

### 1. Create Your Project

Click "**Use this template**" → "**Create a new repository**" → Name your project

### 2. Setup Development Environment

```bash
# Clone your new repository
git clone https://github.com/yourusername/your-project-name.git
cd your-project-name

# Install pixi (if not already installed)
curl -fsSL https://pixi.sh/install.sh | bash

# Install dependencies
pixi install

# Verify everything works
pixi run build
pixi run test
```

### 3. Customize the Template

1. **Update project metadata** in `pixi.toml`:

   ```toml
   [workspace]
   name = "your-project-name"
   description = "Your project description"
   authors = ["Your Name <your.email@example.com>"]
   ```

2. **Rename the package** in `src/`:

   ```bash
   mv src/package_name src/your_package_name
   ```

3. **Update imports** in all files to use your package name

4. **Add your code** following the strict standards

## 📁 Project Structure

```text
your-mojo-project/
├── src/                          # 📚 Library source code
│   └── package_name/
│       ├── __init__.mojo         # Package exports  
│       ├── core.mojo             # Core functionality
│       └── utils.mojo            # Utility functions
├── bin/                          # 🎯 Executable files
│   └── hello.mojo                # Example CLI application
├── tests/                        # 🧪 Test files
│   ├── test_core.mojo
│   └── test_utils.mojo
├── examples/                     # 📖 Usage examples
│   └── basic_usage.mojo
├── benchmarks/                   # ⚡ Performance benchmarks
│   └── core_performance.mojo
├── docs/                         # 📄 Documentation
│   └── README.md
├── build/                        # 🏗️ Build artifacts (auto-generated)
├── .github/                      # 🤖 GitHub configuration
│   ├── workflows/ci.yml          # CI/CD pipeline
│   ├── ISSUE_TEMPLATE/           # Issue templates
│   └── PULL_REQUEST_TEMPLATE.md
├── pixi.toml                     # 📦 Project configuration
├── tasks.sh                      # 🛠️ Build automation
├── CLAUDE.md                     # 🤖 Claude AI assistant config
├── GEMINI.md                     # 🤖 Gemini AI assistant config
├── .gitignore                    # 🚫 Git ignore rules
├── LICENSE                       # ⚖️ License file
├── README.md                     # 📋 This file
├── CONTRIBUTING.md               # 🤝 Contribution guide
└── CONTRIBUTING.md.template      # 📝 Template for your project
```

## 🛠️ Development Commands

All commands use strict compilation settings with zero tolerance for warnings:

### Building

```bash
# Build entire project (all directories)
pixi run build

# Build specific file  
pixi run build src/package_name/core.mojo

# Build with custom output
pixi run build bin/hello.mojo -o build/my_app
```

**Note**: The build system automatically:
- Formats code before building
- Adds import paths for cross-directory imports
- Detects file types (executable vs library module)

### Running

```bash
# Run any .mojo file (auto-builds first)
pixi run run examples/basic_usage.mojo

# Run with arguments
pixi run run bin/hello.mojo Alice Bob
```

### Testing

```bash
# Run all tests
pixi run test

# Run specific test file
pixi run test tests/test_core.mojo
```

### Maintenance

```bash
# Clean all build artifacts
pixi run clean

# Clean including pixi cache
pixi run clean --cache
```

## 📋 Strict Requirements

This template enforces **professional-grade code standards**:

### 1. **Mandatory Documentation**

Every function must have complete docstrings:

```mojo
fn calculate_area(width: Float64, height: Float64) -> Float64:
    """Calculate the area of a rectangle.
    
    Args:
        width: Width of the rectangle in units.
        height: Height of the rectangle in units.
        
    Returns:
        Area of the rectangle in square units.
        
    Examples:
        >>> calculate_area(5.0, 3.0)
        15.0
    """
    return width * height
```

### 2. **Zero Warnings Policy**

All compilation warnings are treated as errors. Code must be warning-free:

```mojo
# ❌ This fails compilation (unused variable)
fn bad_example():
    var unused_var = 42
    print("Hello")

# ✅ This compiles successfully
fn good_example():
    var _ = 42  # Explicitly mark as unused
    print("Hello")
```

### 3. **Modern Mojo Syntax**

Use current Mojo conventions:

```mojo
struct MyStruct:
    fn __init__(out self: MyStruct):  # Constructors use 'out self'
        pass
    
    fn mutate(mut self: MyStruct):    # Mutating methods use 'mut self'
        pass
    
    fn read(self: MyStruct) -> Int:   # Read-only methods use 'self'
        return 42
```

### 4. **Comprehensive Testing**

Every public function must have tests:

```mojo
fn test_calculate_area():
    """Test area calculation with various inputs."""
    assert_equal(calculate_area(5.0, 3.0), 15.0)
    assert_equal(calculate_area(0.0, 10.0), 0.0)
    assert_equal(calculate_area(2.5, 4.0), 10.0)
```

### 5. **Runtime Safety**

All builds include:
- Thread sanitizer for concurrency bugs
- Debug assertions for runtime checks  
- Maximum diagnostic output for debugging

## 🔧 Customization

### Adding Dependencies

Edit `pixi.toml` to add Python packages:

```toml
[pypi-dependencies]
numpy = "*"
matplotlib = "*"
pandas = ">=2.0"
```

Then run:

```bash
pixi install
```

### AI Assistant Configuration

This template includes configuration files for AI coding assistants:
- **CLAUDE.md** - Instructions for Claude (claude.ai)
- **GEMINI.md** - Instructions for Gemini

These ensure AI assistants understand the strict requirements and project structure.

### Project-Specific Configuration

Customize the build process by modifying `tasks.sh`. The current implementation provides strict compilation with automatic import path management.

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Development setup instructions
- Code quality standards  
- Testing requirements
- Pull request process
- Community guidelines

For your own projects, use [CONTRIBUTING.md.template](CONTRIBUTING.md.template) as a starting point.

## 📚 Examples

The template includes working examples:

- **`bin/hello.mojo`** - Simple CLI application
- **`examples/basic_usage.mojo`** - Package usage demonstration  
- **`benchmarks/core_performance.mojo`** - Performance measurement
- **Test files** - Comprehensive test coverage examples

Run examples directly:

```bash
# Examples and benchmarks run as executables
pixi run run examples/basic_usage.mojo
pixi run run benchmarks/core_performance.mojo

# Or build first
pixi run build examples/basic_usage.mojo
./build/basic_usage
```

## 🎯 Use Cases

This template is perfect for:

- **Libraries** - High-performance Mojo libraries
- **Applications** - CLI tools and applications
- **Research** - Scientific computing projects
- **Learning** - Educational Mojo projects
- **Open Source** - Community Mojo packages

## 🔗 Related Resources

- [Mojo Documentation](https://docs.modular.com/mojo/) - Official Mojo language docs
- [Modular Developer Hub](https://developer.modular.com/) - Community and resources
- [Pixi Documentation](https://pixi.sh/) - Package manager documentation
- [Python Packaging Guide](https://packaging.python.org/) - Packaging standards inspiration

## ⚖️ License

This template is released into the **public domain** under the [Unlicense](LICENSE). You can do absolutely anything with it - use, modify, distribute, or sell without any restrictions whatsoever.

Projects created from this template can use any license you choose.

## 🙏 Acknowledgments

- **Modular Team** - For creating the incredible Mojo language
- **Python Packaging Authority** - For the packaging standards this template adapts
- **Prefix.dev** - For the excellent Pixi package manager
- **Mojo Community** - For feedback and contributions

---

**Ready to build something amazing with Mojo?** 🔥  
Use this template to get started!