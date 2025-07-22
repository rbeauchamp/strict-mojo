"""Core functionality demonstrating Mojo best practices.

This module provides example functions that showcase:
- Proper documentation standards
- Type annotations
- Error handling
- Performance considerations
"""


fn add(a: Int, b: Int) -> Int:
    """Add two integers together.

    Args:
        a: First integer operand.
        b: Second integer operand.

    Returns:
        The sum of a and b.

    Examples:
        >>> add(5, 3)
        8.
    """
    return a + b


fn multiply(a: Int, b: Int) -> Int:
    """Multiply two integers together.

    Args:
        a: First integer operand.
        b: Second integer operand.

    Returns:
        The product of a and b.

    Examples:
        >>> multiply(4, 7)
        28.
    """
    return a * b


fn greet(name: String) -> String:
    """Generate a greeting message for the given name.

    Args:
        name: The name to greet.

    Returns:
        A formatted greeting string.

    Examples:
        >>> greet("Mojo")
        "Hello, Mojo! Welcome to strict Mojo development.".
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

    Examples:
        >>> fibonacci(10)
        55.
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
