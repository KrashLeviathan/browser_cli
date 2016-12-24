library process.alias;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/environment_variables.dart';
import 'package:browser_cli/utils.dart';

class AliasProcessFactory extends ProcessFactory {
  static final String COMMAND = 'alias';
  static final String USAGE = 'USAGE: alias <alias_command>=<actual_command>';
  static final String SHORT_DESCRIPTION =
      'Creates an alias that can be used in place of a command in the CLI.';
  static final String LONG_DESCRIPTION = 'Creates an alias that can be used in '
      'place of a command in the CLI. To use the alias, just type it in as you '
      'would a normal command. Additional parameters can be given after the '
      'alias is typed. For example, one of the built-in aliases is `commands`, '
      'which is an alias for `help -l`. If you type in `commands -v`, it will '
      'be the same as if you had typed in `help -l -v`.';
  static String get lastAliasAdded => _lastAliasAdded;
  static String _lastAliasAdded;

  AliasProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, true,
            ProcessAccessibility.VERBOSE_VISIBLE);

  AliasProcess createProcess(int id, List args) =>
      new AliasProcess(id, COMMAND, args, this);
}

/// Creates a permanent variable that
/// will be recalled in future browser session. Uses the browser cookies to
/// store the variable. To erase a variable, use the 'unset' command.
/// The <value> can be wrapped in single or double quotes, but it doesn't
/// have to be. If it is wrapped in quotes, the outermost pair of quotes is
/// stripped off the value before storing in the variable.
class AliasProcess extends Process {
  AliasProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      await _parseArgs();
    } else {
      await output(new DivElement()..text = factory.usage);
      exit(1);
    }
  }

  _parseArgs() {
    var combinedArgs = args.join(' ');
    if (EnvVars.assignmentRegExp.hasMatch(combinedArgs)) {
      EnvVars.assignmentRegExp.allMatches(combinedArgs).forEach((match) {
        new EnvVars().aliasMappings[match.group(1)] =
            trimAndStripQuotes(match.group(2));
        AliasProcessFactory._lastAliasAdded = match.group(1);
      });
    } else {
      // Found something that shouldn't be there.
      output(new DivElement()..text = factory.usage);
      exit(1);
    }
  }
}
