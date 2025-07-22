"""Example executable demonstrating a simple CLI application.

This file serves as a template for command-line applications.
Built with: pixi run build bin/hello.mojo
Run with: ./build/hello
"""

from sys import argv


fn main() raises:
    """Entry point for the hello world CLI application.

    Demonstrates basic argument handling and output.
    """
    var name: String
    if len(argv()) <= 1:
        name = "World"
    else:
        name = argv()[1]

    print("Hello, " + name + "!")
    print("This executable was built with strict compilation standards.")
