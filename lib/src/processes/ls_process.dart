library process.ls;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class LsProcessFactory extends ProcessFactory {
  static final String COMMAND = 'ls';

  LsProcessFactory() : super(COMMAND);

  LsProcess createProcess(int id, List args) =>
      new LsProcess(id, COMMAND, args);
}

class LsProcess extends Process {
  LsProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // TODO
    await output(new DivElement()..text='LsProcess.start()');
    exit(0);
  }
}
