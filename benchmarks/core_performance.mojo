"""Performance benchmarks for core Mojo functions.

This file demonstrates:
- Performance measurement techniques
- Benchmarking best practices
- Comparative analysis
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


fn format_duration(nanoseconds: Int) -> String:
    """Format a duration in nanoseconds into a human-readable string.

    Args:
        nanoseconds: Duration in nanoseconds.

    Returns:
        Formatted string with appropriate time units.
    """
    var ns = nanoseconds

    # Convert to different units for readability
    if ns >= 1_000_000_000:  # >= 1 second
        var seconds = ns // 1_000_000_000
        var fraction = (ns % 1_000_000_000) // 10_000_000  # 2 decimal places
        return String(seconds) + "." + String(fraction) + " seconds"
    elif ns >= 1_000_000:  # >= 1 millisecond
        var millis = ns // 1_000_000
        var fraction = (ns % 1_000_000) // 10_000  # 2 decimal places
        return String(millis) + "." + String(fraction) + " milliseconds"
    elif ns >= 1_000:  # >= 1 microsecond
        var micros = ns // 1_000
        var fraction = ns % 1_000
        return String(micros) + "." + String(fraction) + " microseconds"
    else:
        return String(ns) + " nanoseconds"


fn benchmark_fibonacci(n: Int, iterations: Int = 1000) raises -> Int:
    """Benchmark the fibonacci function.

    Args:
        n: The fibonacci number to calculate.
        iterations: Number of iterations to run.

    Returns:
        Average time per iteration in nanoseconds.
    """
    var start_time = Int(perf_counter_ns())

    for _ in range(iterations):
        var _ = fibonacci(n)

    var end_time = Int(perf_counter_ns())
    var total_time = end_time - start_time
    return total_time // iterations


fn benchmark_arithmetic(iterations: Int = 1_000_000) -> Int:
    """Benchmark basic arithmetic operations.

    Args:
        iterations: Number of iterations to run.

    Returns:
        Average time per iteration in nanoseconds.
    """
    var start_time = Int(perf_counter_ns())

    for i in range(iterations):
        var _ = add(i, i + 1)
        var _ = multiply(i, 2)

    var end_time = Int(perf_counter_ns())
    var total_time = end_time - start_time
    return total_time // iterations


fn main() raises:
    """Run performance benchmarks and display results.

    This function executes various benchmarks to measure the performance
    of core functions.
    """
    print("=== Performance Benchmarks ===")
    print()

    # Benchmark Fibonacci function with different input sizes
    print("Fibonacci performance (1000 iterations each):")

    # Use individual variables instead of tuple iteration
    var fib_inputs = List[Int](10, 15, 20, 25, 30)

    for i in range(len(fib_inputs)):
        var n = fib_inputs[i]
        var avg_time = benchmark_fibonacci(n)
        print(
            "  fibonacci("
            + String(n)
            + "): "
            + format_duration(avg_time)
            + " per call"
        )

    print()

    # Benchmark arithmetic operations
    print("Arithmetic operations performance:")
    var arithmetic_time = benchmark_arithmetic()
    print(
        "  add + multiply: "
        + format_duration(arithmetic_time)
        + " per pair of operations"
    )

    print()

    # Demonstrate scaling behavior
    print("Fibonacci scaling analysis:")
    var prev_time = benchmark_fibonacci(10)

    for n in range(11, 21):
        var curr_time = benchmark_fibonacci(n)
        var ratio = Float64(curr_time) / Float64(prev_time)
        print(
            "  fibonacci("
            + String(n)
            + ") is "
            + String(ratio)
            + "x slower than fibonacci("
            + String(n - 1)
            + ")"
        )
        prev_time = curr_time

    print()
    print("=== Benchmarks completed ===")
    print("Note: Times may vary based on system load and hardware.")
