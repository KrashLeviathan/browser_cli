library process.printenv;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/environment_variables.dart';
import 'package:browser_cli/process_manager.dart';

class PrintEnvProcessFactory extends ProcessFactory {
  static final String COMMAND = 'printenv';
  static final String USAGE = 'USAGE: printenv';
  static final String SHORT_DESCRIPTION =
      'Prints all environment variables and aliases.';
  static final String LONG_DESCRIPTION =
      'Prints all environment variables and aliases.';

  PrintEnvProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, true,
            ProcessAccessibility.VERBOSE_VISIBLE);

  PrintEnvProcess createProcess(int id, List args) =>
      new PrintEnvProcess(id, COMMAND, args, this);
}

/// Prints all environment variables and aliases to the shell.
class PrintEnvProcess extends Process {
  PrintEnvProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    var ev = new EnvVars();
    if (args.isNotEmpty) {
      output(new DivElement()..text = factory.usage);
      exit(1);
    }
    var envVars = ev.variablesCopy;

    var div = new DivElement();
    div.append(new ParagraphElement()..text = "Variables:");

    var uList = new UListElement();
    envVars.keys.forEach((key) {
      uList.append(new LIElement()..innerHtml = "<b>$key</b>: ${envVars[key]}");
    });
    if (envVars.keys.isEmpty) {
      uList.append(new LIElement()..text = "NONE");
    }
    div.append(uList);

    div.append(new ParagraphElement()..text = "Aliases:");

    var aliasUList = new UListElement();
    ev.aliasMappings.keys.forEach((key) {
      aliasUList.append(
          new LIElement()..innerHtml = "<b>$key</b>: ${ev.aliasMappings[key]}");
    });
    if (ev.aliasMappings.keys.isEmpty) {
      aliasUList.append(new LIElement()..text = "NONE");
    }
    div.append(aliasUList);

    await output(div);
  }
}
