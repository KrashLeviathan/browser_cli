library process.cd;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class CdProcessFactory extends ProcessFactory {
  static final String COMMAND = 'cd';

  CdProcessFactory() : super(COMMAND);

  CdProcess createProcess(int id, List args) =>
      new CdProcess(id, COMMAND, args);
}

class CdProcess extends Process {
  CdProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // TODO
    await output(new DivElement()..text='CdProcess.start()');
    exit(0);
  }
}
