part of utils;

/// This class is used to separate a command from it's arguments. It also does
/// input sanitization so that someone can't enter escape characters and other
/// things that aren't allowed.
class ParsedInput {
  /// The command for this piece of input. Consistgs of the first token in the
  /// string.
  final String command;

  /// The arguments for this piece of input. Consists of the tokens following
  /// the command (first) token.
  final List args;

  /// The default constructor. However, the ParsedInput.fromString() is the
  /// more commonly used way to construct a [ParsedInput] object.
  ParsedInput(this.command, this.args);

  /// Creates a [ParsedInput] object from the given input [String].
  factory ParsedInput.fromString(String input) {
    var tokens = _splitTokens(sanitize(input));
    if (tokens.isEmpty) {
      return null;
    }
    var commandToken = tokens.removeAt(0).trim();
    var arguments = new List()..addAll(tokens.where((str) => str.isNotEmpty));
    return new ParsedInput(commandToken, arguments);
  }

  /// Removes escape characters and other things that aren't allowed.
  static String sanitize(String str) {
    // TODO: Revisit Input Sanitization & Security
    // However, I think since we're setting the text of the html elements
    // (rather than the innerHtml), it should be safe without this implemented.
    // Unless we plan on doing something else with the input, such as storing
    // it in a cookie, database, session storage, etc.    return str;
    return str;
  }

  static List<String> _splitTokens(String input) {
    var splitString = input.trim().split(' ');
    return splitString.where((token) => token.trim().isNotEmpty).toList();
  }

  String toString() => 'ParsedInput[ command: $command, args: $args ]';
}
