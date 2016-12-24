library process.unset;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/environment_variables.dart';

class UnsetProcessFactory extends ProcessFactory {
  static final String COMMAND = 'unset';
  static final String USAGE =
      'USAGE: unset <var_name1> [<var_name2> <var_name3> ...]';
  static final String SHORT_DESCRIPTION = 'Erases an environment variable.';
  static final String LONG_DESCRIPTION = 'Erases an environment variable. '
      'Multiple variable names can be entered as arguments. If an argument '
      'does not match a valid variable name, a warning message will output to '
      'the shell, but the remaining arguments will continue to be processed.';

  UnsetProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, true, ProcessAccessibility.VERBOSE_VISIBLE);

  UnsetProcess createProcess(int id, List args) =>
      new UnsetProcess(id, COMMAND, args, this);
}

/// Erases an environment variable.
/// Multiple variable names can be entered as arguments. If an argument
/// does not match a valid variable name, a warning message will output to
/// the shell, but the remaining arguments will continue to be processed.
class UnsetProcess extends Process {
  UnsetProcess(int id, String command, List args, ProcessFactory factory)
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
    var envVars = new EnvVars();
    args.forEach((arg) {
      if (!envVars.unset(arg)) {
        output(new DivElement()
          ..text = "Variable `$arg` does not exist! Skipping...");
      }
    });
  }
}
