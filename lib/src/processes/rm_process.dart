library process.rm;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class RmProcessFactory extends ProcessFactory {
  static final String COMMAND = 'rm';

  RmProcessFactory() : super(COMMAND);

  RmProcess createProcess(int id, List args) =>
      new RmProcess(id, COMMAND, args);
}

class RmProcess extends Process {
  RmProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // TODO
    await output(new DivElement()..text='RmProcess.start()');
    exit(0);
  }
}
