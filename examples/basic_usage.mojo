"""Basic usage example demonstrating the strict Mojo project structure.

This example shows how to use the package modules in a typical application.
It demonstrates:
- Importing from the package
- Using core functions
- Utilizing the Timer utility
- Proper error handling
"""

from package_name.core import add, multiply, greet, fibonacci
from package_name.utils import Timer, format_duration


fn demonstrate_arithmetic():
    """Show basic arithmetic operations from the core module."""
    print("Arithmetic operations:")
    print("  add(5, 3) =", add(5, 3))
    print("  multiply(4, 7) =", multiply(4, 7))
    print()


fn demonstrate_strings():
    """Show string operations from the core module."""
    print("String operations:")
    print("  " + greet("Developer"))
    print("  " + greet("Mojo Community"))
    print()


fn demonstrate_timing():
    """Show how to use the Timer utility for performance measurement."""
    print("Timer utility:")
    var timer = Timer()
    
    # Time a simple computation
    timer.start()
    var result = 0
    for i in range(1_000_000):
        result += i
    var elapsed = timer.stop()
    
    print("  Sum of first 1,000,000 integers:", result)
    print("  Time elapsed:", format_duration(elapsed))
    print()


fn demonstrate_fibonacci() raises:
    """Show fibonacci function usage with error handling."""
    print("Fibonacci sequence:")
    
    # Calculate and display first few fibonacci numbers
    for i in range(8):
        print("  fib(" + String(i) + ") =", fibonacci(i))
    
    print()
    print("Error handling:")
    try:
        var _ = fibonacci(-5)
    except e:
        print("  Caught expected error:", e)
    print()


fn measure_function_performance() raises:
    """Demonstrate timing individual function calls."""
    print("Performance measurement:")
    var timer = Timer()
    
    # Measure fibonacci performance
    timer.start()
    var fib_result = fibonacci(30)
    var fib_time = timer.stop()
    print("  fibonacci(30) =", fib_result)
    print("  Computation time:", format_duration(fib_time))
    
    # Measure batch operations
    timer.start()
    var total = 0
    for i in range(1000):
        total += add(i, i + 1)
        total += multiply(i % 10, 2)
    var batch_time = timer.stop()
    print("  1000 arithmetic operations took:", format_duration(batch_time))
    print()


fn main() raises:
    """Main entry point demonstrating package usage.
    
    This example shows how to structure a Mojo application using
    the strict project template with proper imports and utilities.
    """
    print("=== Strict Mojo Project Template Example ===")
    print()
    
    # Demonstrate various functionalities
    demonstrate_arithmetic()
    demonstrate_strings()
    demonstrate_timing()
    demonstrate_fibonacci()
    measure_function_performance()
    
    print("=== Example completed successfully! ===")
    print("This demonstrates the basic project structure and usage patterns.")