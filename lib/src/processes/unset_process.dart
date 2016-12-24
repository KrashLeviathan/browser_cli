library process.unset;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/environment_variables.dart';

class UnsetProcessFactory extends ProcessFactory {
  static final String COMMAND = 'unset';
  static final String USAGE =
      'USAGE: unset [alias] <name1> [<name2> <name3> ...]';
  static final String SHORT_DESCRIPTION =
      'Erases an environment variable or alias.';
  static final String LONG_DESCRIPTION =
      'Erases an environment variable or alias. '
      'Multiple names can be entered as arguments. If an argument '
      'does not match a valid variable/alias name, a warning message will output to '
      'the shell, but the remaining arguments will continue to be processed. '
      'If `unset alias ...` is used, it is assumed that all the names that '
      'follow are alias names, NOT variable names.';

  UnsetProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, true,
            ProcessAccessibility.VERBOSE_VISIBLE);

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

  var envVars = new EnvVars();

  Future start() async {
    if (args.isNotEmpty) {
      await _parseArgs();
    } else {
      await output(new DivElement()..text = factory.usage);
      exit(1);
    }
  }

  _parseArgs() {
    if (args[0] == 'alias') {
      _unsetAliases();
      return;
    }
    args.forEach((arg) {
      if (!envVars.unset(arg)) {
        output(new DivElement()
          ..text = "Variable `$arg` does not exist! Skipping...");
      }
    });
  }

  _unsetAliases() {
    if (args.length == 1) {
      output(new DivElement()
        ..text = "Please list the aliases you would like to unset.");
      exit(1);
      return;
    }
    var aliases = args.sublist(1);
    aliases.forEach((alias) {
      if (!envVars.unsetAlias(alias)) {
        output(new DivElement()
          ..text = "Alias `$alias` does not exist! Skipping...");
      }
    });
  }
}
