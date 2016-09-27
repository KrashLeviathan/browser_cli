part of utils;

/// The CLI class gives definitions for CSS id and class references
class CLI {
  /// The prefix that comes before all browser_cli id's and classes in HTML.
  /// This helps namespace clashes with other user styles on a web page.
  static const prefix = 'cli';

  /// Html id of the container for the CLI shell.
  static const String SHELL = '$prefix-shell';

  /// Html id of the div the user types in.
  static const String STANDARD_INPUT = '$prefix-standard-input';

  /// This class applies to input that is intended for a certain process. The
  /// string is a prefix that will have the process id attached to the end.
  static const String INPUT_FOR_PROCESS = '$prefix-input-for-process';

  /// Html id of the leading bit of text in the standard input div.
  static const String PROMPT = '$prefix-prompt';

  /// Html id of the last div output to the shell.
  static const String LAST_OUTPUT = '$prefix-last-output';

  /// This class applies to all output divs.
  static const String OUTPUT = '$prefix-output';

  /// This class is added to an output div when it's displaying
  /// an error message.
  static const String STDERR = '$prefix-stderr';

  /// This class applies to all (current and previous) input divs.
  static const String INPUT = '$prefix-input';

  /// This class is applied when you want a scrollbar in an output
  /// div.
  static const String VISIBLE_SCROLL = '$prefix-visible-scroll';

  /// This class is applied when you want the scroll area to have
  /// a border.
  static const String BORDERED_SCROLL_AREA = '$prefix-bordered-scroll-area';

  /// This class is applied when you want something to be hidden.
  static const String HIDDEN = '$prefix-hidden';
}
