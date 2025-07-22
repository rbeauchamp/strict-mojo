"""Performance benchmarks for core Mojo functions.

This file demonstrates:
- Performance measurement using Timer utility
- Benchmarking of core module functions
- Comparative analysis and scaling behavior
"""

from package_name.core import add, multiply, fibonacci
from package_name.utils import Timer, format_duration


fn benchmark_fibonacci(n: Int, iterations: Int = 1000) raises -> Int:
    """Benchmark the fibonacci function from core module.

    Args:
        n: The fibonacci number to calculate.
        iterations: Number of iterations to run.

    Returns:
        Average time per iteration in nanoseconds.
    """
    var timer = Timer()
    var accumulator = 0  # Prevent optimization

    timer.start()
    for _ in range(iterations):
        accumulator += fibonacci(n)
    var total_time = timer.stop()

    # Use accumulator to prevent dead code elimination
    if accumulator == 0:
        print("Unexpected result")

    return total_time // iterations


fn benchmark_arithmetic(iterations: Int = 1_000_000) -> Int:
    """Benchmark basic arithmetic operations from core module.

    Args:
        iterations: Number of iterations to run.

    Returns:
        Average time per iteration in nanoseconds.
    """
    var timer = Timer()
    var accumulator = 0  # Prevent optimization

    timer.start()
    for i in range(iterations):
        accumulator += add(i, i + 1)
        accumulator += multiply(i % 100, 2)
    var total_time = timer.stop()

    # Use accumulator to prevent dead code elimination
    if accumulator == 0:
        print("Unexpected result")

    return total_time // iterations


fn benchmark_single_operation(
    operation: String, iterations: Int = 1_000_000
) -> Int:
    """Benchmark a single arithmetic operation.

    Args:
        operation: The operation to benchmark ("add" or "multiply").
        iterations: Number of iterations to run.

    Returns:
        Average time per operation in nanoseconds.
    """
    var timer = Timer()
    var accumulator = 0

    if operation == "add":
        timer.start()
        for i in range(iterations):
            accumulator += add(i % 1000, (i + 1) % 1000)
        var total_time = timer.stop()
        if accumulator == 0:
            print("Unexpected result")
        return total_time // iterations
    elif operation == "multiply":
        timer.start()
        for i in range(iterations):
            accumulator += multiply(i % 100, 2)
        var total_time = timer.stop()
        if accumulator == 0:
            print("Unexpected result")
        return total_time // iterations
    else:
        return 0


fn warm_up() raises:
    """Perform warm-up operations to ensure consistent timing."""
    print("Warming up...")
    # Run some operations to warm up the CPU
    var warmup_accumulator = 0
    for _ in range(1000):
        warmup_accumulator += fibonacci(20)
    for i in range(10000):
        warmup_accumulator += add(i, i + 1)
        warmup_accumulator += multiply(i, 2)
    # Use the accumulator to prevent optimization
    if warmup_accumulator == 0:
        print("Unexpected warmup result")


fn run_comprehensive_benchmarks() raises:
    """Run a comprehensive suite of benchmarks with detailed timing.

    This function demonstrates advanced usage of the Timer class
    for performance analysis.
    """
    print("=== Comprehensive Performance Analysis ===")
    print()

    # Overall benchmark timer
    var total_timer = Timer()
    total_timer.start()

    # Individual operation benchmarks with higher iteration counts
    print("Individual Operation Performance (10M iterations):")
    var add_time = benchmark_single_operation("add", 10_000_000)
    print("  add(): " + format_duration(add_time) + " per call")

    var mult_time = benchmark_single_operation("multiply", 10_000_000)
    print("  multiply(): " + format_duration(mult_time) + " per call")

    print()

    # Fibonacci benchmarks with timing each test
    print("Fibonacci Performance Analysis:")
    var fib_timer = Timer()

    # Use larger fibonacci numbers for more measurable work
    var test_sizes = List[Int](20, 25, 30, 35, 40)
    var results = List[Int]()

    for i in range(len(test_sizes)):
        var n = test_sizes[i]
        fib_timer.start()
        var avg_time = benchmark_fibonacci(n, 1000)
        var benchmark_time = fib_timer.stop()
        results.append(avg_time)

        print(
            "  fib("
            + String(n)
            + "): "
            + format_duration(avg_time)
            + " per call"
            + " (benchmark took "
            + format_duration(benchmark_time)
            + ")"
        )

    print()

    # Scaling analysis
    print("Fibonacci Scaling Ratios:")
    for i in range(1, len(results)):
        if results[i - 1] > 0:
            var ratio = Float64(results[i]) / Float64(results[i - 1])
            print(
                "  fib("
                + String(test_sizes[i])
                + ") / fib("
                + String(test_sizes[i - 1])
                + ") = "
                + String(ratio)
                + "x"
            )
        else:
            print(
                "  fib("
                + String(test_sizes[i])
                + ") / fib("
                + String(test_sizes[i - 1])
                + ") = N/A (denominator is 0)"
            )

    var total_time = total_timer.stop()
    print()
    print("Total benchmark time: " + format_duration(total_time))


fn main() raises:
    """Run performance benchmarks and display results.

    This function executes various benchmarks to measure the performance
    of core functions using the Timer utility class.
    """
    print("=== Core Module Performance Benchmarks ===")
    print()

    # Warm up before benchmarking
    warm_up()
    print()

    # Quick benchmarks
    print("Quick Performance Check:")

    # Time the arithmetic benchmark itself
    var timer = Timer()
    timer.start()
    var arithmetic_avg = benchmark_arithmetic(1_000_000)
    var bench_time = timer.stop()

    print(
        "  Arithmetic operations: "
        + format_duration(arithmetic_avg)
        + " per pair (benchmark took "
        + format_duration(bench_time)
        + ")"
    )

    print()

    # Fibonacci performance with larger numbers
    print("Fibonacci Performance (1000 iterations each):")

    var fib_inputs = List[Int](20, 25, 30, 35, 40)

    for i in range(len(fib_inputs)):
        var n = fib_inputs[i]
        timer.start()
        var avg_time = benchmark_fibonacci(n)
        var _ = timer.stop()

        print(
            "  fibonacci("
            + String(n)
            + "): "
            + format_duration(avg_time)
            + " per call"
        )

    print()

    # Run comprehensive benchmarks
    run_comprehensive_benchmarks()

    print()
    print("=== Benchmarks completed ===")
    print("Note: Times may vary based on system load and hardware.")
