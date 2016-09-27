library utils;

/// The max integer number.
const int MAX_INT = 4294967296;

/// The non-line-breaking space character for HTML
const String nonBreakingLineSpace = r'&nbsp;';

/// The prompt text used for the CommandLineInterface if one is not defined.
const String standardPromptText = r'~ user$';

/// The CLI class gives definitions for CSS id and class references
class CLI {
  static const _prefix = 'cli';

  /// Html id of the container for the CLI shell.
  static const String SHELL = '$_prefix-shell';

  /// Html id of the div the user types in.
  static const String STANDARD_INPUT = '$_prefix-standard-input';

  /// This class applies to input that is intended for a certain process. The
  /// string is a prefix that will have the process id attached to the end.
  static const String INPUT_FOR_PROCESS = '$_prefix-input-for-process';

  /// Html id of the leading bit of text in the standard input div.
  static const String PROMPT = '$_prefix-prompt';

  /// Html id of the last div output to the shell.
  static const String LAST_OUTPUT = '$_prefix-last-output';

  /// This class applies to all output divs.
  static const String OUTPUT = '$_prefix-output';

  /// This class is added to an output div when it's displaying
  /// an error message.
  static const String STDERR = '$_prefix-stderr';

  /// This class applies to all (current and previous) input divs.
  static const String INPUT = '$_prefix-input';

  /// This class is applied when you want a scrollbar in an output
  /// div.
  static const String VISIBLE_SCROLL = '$_prefix-visible-scroll';

  /// This class is applied when you want the scroll area to have
  /// a border.
  static const String BORDERED_SCROLL_AREA = '$_prefix-bordered-scroll-area';

  /// This class is applied when you want something to be hidden.
  static const String HIDDEN = '$_prefix-hidden';
}

/// Trims the whitespace from the ends of the [String] and removes one pair
/// of quotations from around the string if there exists a matching set of
/// quotation marks.
///
/// Examples:
/// 'Hello''' becomes Hello''
/// World" becomes World"
/// ""Foo"" becomes "Foo"
String trimAndStripQuotes(String str) {
  var trimmed = str.trim();
  if (trimmed.startsWith('"') && trimmed.endsWith('"')) {
    return trimmed.substring(1, trimmed.length - 1);
  } else if (trimmed.startsWith("'") && trimmed.endsWith("'")) {
    return trimmed.substring(1, trimmed.length - 1);
  } else {
    return trimmed;
  }
}

// TODO: Alias system
/// These mappings create some useful aliases for other commands until a
/// better system for aliases is put in place.
final Map<String, String> supplementaryCommandMappings = {
  '?': 'help',
  'commands': 'help -l'
};

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
