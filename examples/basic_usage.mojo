"""Basic usage example showing core Mojo functionality.

This file demonstrates:
- Basic arithmetic operations
- String operations
- Simple timing
- Error handling
"""

from time import perf_counter_ns


fn add(a: Int, b: Int) -> Int:
    """Add two integers together.

    Args:
        a: First integer operand.
        b: Second integer operand.

    Returns:
        The sum of a and b.
    """
    return a + b


fn multiply(a: Int, b: Int) -> Int:
    """Multiply two integers together.

    Args:
        a: First integer operand.
        b: Second integer operand.

    Returns:
        The product of a and b.
    """
    return a * b


fn greet(name: String) -> String:
    """Generate a greeting message for the given name.

    Args:
        name: The name to greet.

    Returns:
        A formatted greeting string.
    """
    return "Hello, " + name + "! Welcome to strict Mojo development."


fn fibonacci(n: Int) raises -> Int:
    """Calculate the nth Fibonacci number.

    Uses an iterative approach for better performance than recursion.

    Args:
        n: The position in the Fibonacci sequence (must be >= 0).

    Returns:
        The nth Fibonacci number.

    Raises:
        Error: If n is negative.
    """
    if n < 0:
        raise Error("Fibonacci input must be non-negative")

    if n <= 1:
        return n

    var prev = 0
    var curr = 1

    for _ in range(2, n + 1):
        var temp = curr
        curr = prev + curr
        prev = temp

    return curr


fn main() raises:
    """Demonstrate basic Mojo functionality.

    Shows examples of arithmetic, strings, timing, and error handling.
    """
    print("=== Basic Usage Examples ===")
    print()

    # Basic arithmetic operations
    print("Basic arithmetic:")
    print("  add(5, 3) =", add(5, 3))
    print("  multiply(4, 7) =", multiply(4, 7))
    print()

    # String operations
    print("Greeting examples:")
    print("  " + greet("Developer"))
    print("  " + greet("Mojo Community"))
    print()

    # Using performance counter for timing
    print("Timer example:")
    var start_time = Int(perf_counter_ns())

    # Do some computational work
    var result = 0
    for i in range(1000000):
        result += i

    var end_time = Int(perf_counter_ns())
    var elapsed = end_time - start_time
    print("  Computed sum of first 1,000,000 integers:", String(result))
    print("  Time elapsed:", String(elapsed), "nanoseconds")
    print()

    # Fibonacci examples with error handling
    print("Fibonacci sequence:")
    for i in range(11):
        print("  fibonacci(" + String(i) + ") =", fibonacci(i))

    print()
    print("Error handling example:")
    try:
        var _ = fibonacci(-5)
    except e:
        print("  Caught expected error:", e)

    print()
    print("=== Example completed successfully! ===")
