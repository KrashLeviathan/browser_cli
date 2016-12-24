library process.export;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/environment_variables.dart';

class ExportProcessFactory extends ProcessFactory {
  static final String COMMAND = 'export';
  static final String USAGE = 'USAGE: export <var_name>=<value>';
  static final String SHORT_DESCRIPTION =
      'Creates a permanent variable that will be recalled in future '
      'browser sessions.';
  static final String LONG_DESCRIPTION = 'Creates a permanent variable that '
      'will be recalled in future browser session. Uses the browser cookies to '
      'store the variable. To erase a variable, use the \'unset\' command. '
      'The <value> can be wrapped in single or double quotes, but it doesn\'t '
      'have to be. If it is wrapped in quotes, the outermost pair of quotes is '
      'stripped off the value before storing in the variable.';

  ExportProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, true,
            ProcessAccessibility.VERBOSE_VISIBLE);

  ExportProcess createProcess(int id, List args) =>
      new ExportProcess(id, COMMAND, args, this);
}

/// Creates a permanent variable that
/// will be recalled in future browser session. Uses the browser cookies to
/// store the variable. To erase a variable, use the 'unset' command.
/// The <value> can be wrapped in single or double quotes, but it doesn't
/// have to be. If it is wrapped in quotes, the outermost pair of quotes is
/// stripped off the value before storing in the variable.
class ExportProcess extends Process {
  ExportProcess(int id, String command, List args, ProcessFactory factory)
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
    if (EnvVars.variableGetsAssigned(combinedArgs, persist: true)) {
      return;
    } else {
      // Found something that shouldn't be there.
      output(new DivElement()..text = factory.usage);
      exit(1);
    }
  }
}
