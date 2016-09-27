library process.printenv;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/environment_variables.dart';
import 'package:browser_cli/process_manager.dart';

class PrintEnvProcessFactory extends ProcessFactory {
  static final String COMMAND = 'printenv';
  static final String USAGE = 'USAGE: printenv';
  static final String SHORT_DESCRIPTION = 'Prints all environment variables.';
  static final String LONG_DESCRIPTION = 'Prints all environment variables.';

  PrintEnvProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  PrintEnvProcess createProcess(int id, List args) =>
      new PrintEnvProcess(id, COMMAND, args, this);
}

/// Prints all environment variables to the shell.
class PrintEnvProcess extends Process {
  PrintEnvProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      output(new DivElement()..text = factory.usage);
      exit(1);
    }
    var envVars = new EnvVars().variablesCopy;

    var div = new DivElement();
    var uList = new UListElement();
    envVars.keys.forEach((key) {
      uList.append(new LIElement()..innerHtml = "<b>$key</b>: ${envVars[key]}");
    });
    div.append(uList);

    await output(div);
  }
}
