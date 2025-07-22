"""Utility functions and classes for the example package.

This module demonstrates:
- Struct definitions
- Method documentation
- Performance measurement utilities
"""

from time import perf_counter_ns


struct Timer:
    """A simple timer utility for measuring execution time.

    This struct provides a clean interface for timing code execution,
    useful for benchmarking and performance analysis.

    Examples:
        >>> timer = Timer()
        >>> timer.start()
        >>> # ... some code to time ...
        >>> elapsed = timer.stop()
        >>> print("Elapsed time:", elapsed, "nanoseconds")
    """

    var _start_time: Int
    var _is_running: Bool

    fn __init__(out self: Timer):
        """Initialize a new Timer instance.

        The timer starts in a stopped state.
        """
        self._start_time = 0
        self._is_running = False

    fn __del__(owned self: Timer):
        """Destructor for Timer instance.

        Cleans up any resources used by the timer.
        """
        pass

    fn start(mut self: Timer):
        """Start the timer.

        Records the current time as the start point.
        If the timer is already running, this resets the start time.
        """
        self._start_time = Int(perf_counter_ns())
        self._is_running = True

    fn stop(mut self: Timer) -> Int:
        """Stop the timer and return elapsed time.

        Returns:
            Elapsed time in nanoseconds since start() was called.
            Returns 0 if the timer was never started.
        """
        if not self._is_running:
            return 0

        var elapsed = Int(perf_counter_ns()) - self._start_time
        self._is_running = False
        return elapsed

    fn is_running(self: Timer) -> Bool:
        """Check if the timer is currently running.

        Returns:
            True if the timer is running, False otherwise.
        """
        return self._is_running


fn _format_with_two_decimals(value: Int, fraction: Int, unit: String) -> String:
    """Helper to format a number with two decimal places."""
    if fraction < 10:
        return String(value) + ".0" + String(fraction) + " " + unit
    return String(value) + "." + String(fraction) + " " + unit


fn format_duration(nanoseconds: Int) -> String:
    """Format a duration in nanoseconds into a human-readable string.

    Args:
        nanoseconds: Duration in nanoseconds.

    Returns:
        Formatted string with appropriate time units.

    Examples:
        >>> format_duration(1500000000)
        "1.50 seconds"
        >>> format_duration(2500000)
        "2.50 milliseconds".
    """
    if nanoseconds >= 1_000_000_000:  # Seconds
        seconds = nanoseconds // 1_000_000_000
        fraction = (nanoseconds % 1_000_000_000) // 10_000_000
        return _format_with_two_decimals(seconds, fraction, "seconds")

    if nanoseconds >= 1_000_000:  # Milliseconds
        milliseconds = nanoseconds // 1_000_000
        fraction = (nanoseconds % 1_000_000) // 10_000
        return _format_with_two_decimals(milliseconds, fraction, "milliseconds")

    if nanoseconds >= 1_000:  # Microseconds
        microseconds = nanoseconds // 1_000
        fraction = (nanoseconds % 1_000) // 10
        return _format_with_two_decimals(microseconds, fraction, "microseconds")

    return String(nanoseconds) + " nanoseconds"
