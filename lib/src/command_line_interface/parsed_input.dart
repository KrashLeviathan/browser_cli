part of command_line_interface;

class ParsedInput {
  final String command;
  final List args;

  ParsedInput(this.command, this.args);

  factory ParsedInput.fromString(String input) {
    var tokens = _sanitizeInput(input);
    if (tokens.isEmpty) {
      return null;
    }
    var commandToken = tokens.removeAt(0).trim();
    var arguments = new List()..addAll(tokens.where((str) => str.isNotEmpty));
    return new ParsedInput(commandToken, arguments);
  }

  static List<String> _sanitizeInput(String input) {
    // TODO: I think since we're setting the text of the html elements, it should be safe
    // without this implemented. Unless we plan on doing something else with the input, such
    // as storing it in a cookie, database, session storage, etc.
    var splitString = input.trim().split(' ');
    return splitString.where((token) => token.trim().isNotEmpty).toList();
  }

  String toString() => 'ParsedInput[ command: $command, args: $args ]';
}
