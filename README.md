# Strict Mojo Template

A template for creating Mojo projects with the strictest possible compiler settings and development practices.

## Features

- 🚨 **Zero Warnings Tolerance** - All warnings are treated as errors
- 📝 **Mandatory Documentation** - All functions must have properly formatted docstrings
- 🎨 **Auto-formatting** - Code is automatically formatted before every build
- 🐛 **Runtime Safety** - Thread sanitizer and debug assertions enabled
- 🔍 **Maximum Diagnostics** - Detailed error messages with full context

## Quick Start

1. **Use this template** to create a new repository
2. **Clone** your new repository
3. **Install pixi** if you haven't already:

   ```bash
   curl -fsSL https://pixi.sh/install.sh | bash
   ```

4. **Install dependencies**:

   ```bash
   pixi install
   ```

5. **Create your first Mojo file** (e.g., `main.mojo`):

   ```mojo
   fn main():
       """Entry point of the program."""
       print("Hello, strict Mojo!")
   ```

6. **Build and run**:

   ```bash
   pixi run build main.mojo -o main
   ./main
   ```

## Available Commands

Only three commands, all ultra-strict:

- `pixi run build <file.mojo> -o <output>` - Build with all safety checks
- `pixi run run <file.mojo>` - Run with all safety checks  
- `pixi run test` - Run tests with all safety checks

## Strict Requirements

### 1. All Functions Must Have Documentation

```mojo
# ❌ This will fail to compile
fn add(a: Int, b: Int) -> Int:
    return a + b

# ✅ This will compile
fn add(a: Int, b: Int) -> Int:
    """Add two integers.
    
    Args:
        a: First integer to add.
        b: Second integer to add.
        
    Returns:
        The sum of a and b.
    """
    return a + b
```

### 2. No Unused Variables Allowed

```mojo
# ❌ This will fail to compile
fn example():
    var unused = 42
    print("Hello")

# ✅ This will compile
fn example():
    var _ = 42  # Use _ for intentionally unused
    print("Hello")
```

### 3. All Warnings Are Errors

The custom `tasks.sh` wrapper ensures that ANY warning will cause compilation to fail.

## Customization

### Adding Python Dependencies

Edit `pixi.toml` and add your dependencies under `[pypi-dependencies]`:

```toml
[pypi-dependencies]
numpy = "*"
pandas = "*"
```

Then run `pixi install` to install them.

### Project Structure

```text
your-project/
├── pixi.toml     # Project configuration
├── tasks.sh      # Strict compilation wrapper
├── README.md     # This file
├── .gitignore    # Git ignore rules
└── src/          # Your Mojo source files
```

## Why So Strict?

This template enforces the highest code quality standards:

- Catches bugs at compile time instead of runtime
- Ensures consistent code documentation
- Prevents common programming mistakes
- Makes code reviews easier
- Improves long-term maintainability

## License

This template is released into the public domain. Use it however you like!
