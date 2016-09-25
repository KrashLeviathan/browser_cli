library utils;

/// The max integer number.
const int MAX_INT = 4294967296;

/// The non-line-breaking space character for HTML
const String nonBreakingLineSpace = r'&nbsp;';

/// The prompt text used for the CommandLineInterface if one is not defined.
const String standardPromptText = r'~ user$';

/// The CLI class gives definitions for CSS id and class references
class CLI {
  /// Html id of the container for the CLI shell.
  static const String SHELL = 'browser-cli-shell';

  /// Html id of the div the user types in.
  static const String STANDARD_INPUT = 'cli-standard-input';

  /// Html id of the leading bit of text in the standard input div.
  static const String PROMPT = 'cli-prompt';

  /// Html id of the last div output to the shell.
  static const String LAST_OUTPUT = 'cli-last-output';

  /// This class applies to all output divs.
  static const String OUTPUT = 'cli-output';

  /// This class is added to an output div when it's displaying
  /// an error message.
  static const String STDERR = 'cli-stderr';

  /// This class applies to all (current and previous) input divs.
  static const String INPUT = 'cli-input';

  /// This class is applied when you want a scrollbar in an output
  /// div.
  static const String VISIBLE_SCROLL = 'cli-visible-scroll';

  /// This class is applied when you want the scroll area to have
  /// a border.
  static const String BORDERED_SCROLL_AREA = 'cli-bordered-scroll-area';

  /// This class is applied when you want something to be hidden.
  static const String HIDDEN = 'cli-hidden';
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
