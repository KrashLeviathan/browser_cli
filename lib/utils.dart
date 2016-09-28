/**
 * This library provides utility functions and variables for browser_cli that
 * can be easily shared across other libraries.
 */
library utils;

part 'src/utils/cli.dart';
part 'src/utils/parsed_input.dart';

/// The max integer number.
const int MAX_INT = 4294967296;

/// The non-line-breaking space character for HTML
const String nonBreakingLineSpace = r'&nbsp;';

/// The prompt text used for the CommandLineInterface if one is not defined.
const String standardPromptText = r'~ user$';

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
