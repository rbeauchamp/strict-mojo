"""Example Mojo module demonstrating strict compilation requirements."""


fn greet(name: String) -> String:
    """Create a personalized greeting.

    Args:
        name: The name of the person to greet.

    Returns:
        A personalized greeting message.
    """
    return "Hello, " + name + "! Welcome to strict Mojo."


fn main():
    """Entry point demonstrating the greet function."""
    var message = greet("Developer")
    print(message)
