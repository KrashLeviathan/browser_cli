library process.printenv;

import 'dart:async';
import 'dart:html';

import 'package:hello_morpheus/environment_variables.dart';
import 'package:hello_morpheus/process_manager.dart';
import 'package:hello_morpheus/utils.dart';

class PrintEnvProcessFactory extends ProcessFactory {
  static final String COMMAND = 'printenv';

  PrintEnvProcessFactory() : super(COMMAND);

  PrintEnvProcess createProcess(int id, List args) =>
      new PrintEnvProcess(id, COMMAND, args);
}

class PrintEnvProcess extends Process {
  PrintEnvProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    var envVars = new EnvVars().printEnv;
    var sanitizedEnvVars = [];
    envVars.forEach((str) {
      sanitizedEnvVars.add(str.replaceAll(' ', nonBreakingLineSpace));
    });
    var div = new DivElement();
    await div.setInnerHtml(sanitizedEnvVars.join('<br>'));
    await output(div);
    exit(0);
  }
}
