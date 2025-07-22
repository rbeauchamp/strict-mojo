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

    fn __init__(inoutself):
        """Initialize a new Timer instance.

        The timer starts in a stopped state.
        """
        self._start_time = 0
        self._is_running = False

    fn start(inoutself):
        """Start the timer.

        Records the current time as the start point.
        If the timer is already running, this resets the start time.
        """
        self._start_time = int(perf_counter_ns())
        self._is_running = True

    fn stop(inoutself) -> Int:
        """Stop the timer and return elapsed time.

        Returns:
            Elapsed time in nanoseconds since start() was called.
            Returns 0 if the timer was never started.
        """
        if not self._is_running:
            return 0

        var elapsed = int(perf_counter_ns()) - self._start_time
        self._is_running = False
        return elapsed

    fn is_running(self) -> Bool:
        """Check if the timer is currently running.

        Returns:
            True if the timer is running, False otherwise.
        """
        return self._is_running


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
        "2.50 milliseconds"
    """
    var ns = nanoseconds

    # Convert to different units for readability
    if ns >= 1_000_000_000:  # >= 1 second
        var seconds = ns // 1_000_000_000
        var fraction = (ns % 1_000_000_000) // 10_000_000  # 2 decimal places
        return str(seconds) + "." + str(fraction).zfill(2) + " seconds"
    elif ns >= 1_000_000:  # >= 1 millisecond
        var millis = ns // 1_000_000
        var fraction = (ns % 1_000_000) // 10_000  # 2 decimal places
        return str(millis) + "." + str(fraction).zfill(2) + " milliseconds"
    elif ns >= 1_000:  # >= 1 microsecond
        var micros = ns // 1_000
        var fraction = ns % 1_000
        return str(micros) + "." + str(fraction).zfill(3) + " microseconds"
    else:
        return str(ns) + " nanoseconds"
