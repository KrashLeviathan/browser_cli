library process.man;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class ManProcessFactory extends ProcessFactory {
  static final String COMMAND = 'man';

  ManProcessFactory() : super(COMMAND);

  ManProcess createProcess(int id, List args) =>
      new ManProcess(id, COMMAND, args);
}

class ManProcess extends Process {
  ManProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // TODO
    await output(new DivElement()..text = 'ManProcess.start()');
    exit(0);
  }
}
