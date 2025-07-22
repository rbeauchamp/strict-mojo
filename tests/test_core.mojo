"""Tests for core module functionality.

This file demonstrates Mojo testing best practices using the built-in
testing framework.
"""

from testing import assert_equal, assert_true, assert_raises
from package_name.core import add, multiply, greet, fibonacci


def test_add():
    """Test the add function with various inputs."""
    assert_equal(add(2, 3), 5)
    assert_equal(add(-1, 1), 0)
    assert_equal(add(0, 0), 0)
    assert_equal(add(-5, -3), -8)


def test_multiply():
    """Test the multiply function with various inputs."""
    assert_equal(multiply(3, 4), 12)
    assert_equal(multiply(-2, 5), -10)
    assert_equal(multiply(0, 100), 0)
    assert_equal(multiply(-3, -4), 12)


def test_greet():
    """Test the greet function with different names."""
    result = greet("Alice")
    assert_true("Alice" in result)
    assert_true("Hello" in result)

    result = greet("Mojo")
    assert_true("Mojo" in result)


def test_fibonacci():
    """Test the fibonacci function with known values."""
    assert_equal(fibonacci(0), 0)
    assert_equal(fibonacci(1), 1)
    assert_equal(fibonacci(2), 1)
    assert_equal(fibonacci(3), 2)
    assert_equal(fibonacci(4), 3)
    assert_equal(fibonacci(5), 5)
    assert_equal(fibonacci(10), 55)


def test_fibonacci_negative():
    """Test that fibonacci raises error for negative input."""
    with assert_raises(contains="non-negative"):
        _ = fibonacci(-1)


def test_fibonacci_large():
    """Test fibonacci with larger values for performance."""
    # This tests both correctness and performance
    result = fibonacci(30)
    assert_equal(result, 832040)
