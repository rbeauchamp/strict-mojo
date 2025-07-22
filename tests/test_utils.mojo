"""Tests for utility module functionality.

This file tests the Timer struct and utility functions.
"""

from testing import assert_equal, assert_true, assert_false
from package_name.utils import Timer, format_duration
from time import sleep


def test_timer_initialization():
    """Test that Timer initializes correctly."""
    var timer = Timer()
    assert_false(timer.is_running())


def test_timer_start_stop():
    """Test basic timer start/stop functionality."""
    var timer = Timer()

    # Timer should not be running initially
    assert_false(timer.is_running())

    # Start the timer
    timer.start()
    assert_true(timer.is_running())

    # Add a small delay to ensure time passes
    # Note: In real tests you might want to use a more controlled approach

    # Stop the timer
    var elapsed = timer.stop()
    assert_false(timer.is_running())

    # Elapsed time should be positive
    assert_true(elapsed >= 0)


def test_timer_multiple_starts():
    """Test that multiple starts reset the timer."""
    var timer = Timer()

    timer.start()
    timer.start()  # This should reset the start time
    assert_true(timer.is_running())

    var elapsed = timer.stop()
    assert_true(elapsed >= 0)


def test_timer_stop_without_start():
    """Test stopping a timer that was never started."""
    var timer = Timer()
    var elapsed = timer.stop()
    assert_equal(elapsed, 0)


def test_format_duration_seconds():
    """Test duration formatting for seconds."""
    # Test 1.5 seconds (1,500,000,000 nanoseconds)
    result = format_duration(1_500_000_000)
    assert_true("1.50 seconds" in result)


def test_format_duration_milliseconds():
    """Test duration formatting for milliseconds."""
    # Test 2.5 milliseconds (2,500,000 nanoseconds)
    result = format_duration(2_500_000)
    assert_true("2.50 milliseconds" in result)


def test_format_duration_microseconds():
    """Test duration formatting for microseconds."""
    # Test 500.123 microseconds (500,123 nanoseconds)
    result = format_duration(500_123)
    assert_true("500.123 microseconds" in result)


def test_format_duration_nanoseconds():
    """Test duration formatting for small values."""
    # Test 999 nanoseconds
    result = format_duration(999)
    assert_true("999 nanoseconds" in result)
