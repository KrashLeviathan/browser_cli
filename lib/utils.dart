library utils;

const int MAX_INT = 4294967296;
const String nonBreakingLineSpace = r'&nbsp;';

const String standardPromptText = r'~ user$';

/// Gives definitions for CSS id and class references
class CLI {
  // id
  static const String SHELL = 'browser-cli-shell';
  static const String STANDARD_INPUT = 'cli-standard-input';
  static const String PROMPT = 'cli-prompt';
  static const String LAST_OUTPUT = 'cli-last-output';

  // class
  static const String OUTPUT = 'cli-output';
  static const String STDERR = 'cli-stderr';
  static const String INPUT = 'cli-input';

  static const String VISIBLE_SCROLL = 'cli-visible-scroll';
  static const String BORDERED_SCROLL_AREA = 'cli-bordered-scroll-area';
  static const String HIDDEN = 'cli-hidden';
}
