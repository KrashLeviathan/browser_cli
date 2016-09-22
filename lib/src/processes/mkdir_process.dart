library process.mkdir;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class MkdirProcessFactory extends ProcessFactory {
  static final String COMMAND = 'mkdir';

  MkdirProcessFactory() : super(COMMAND);

  MkdirProcess createProcess(int id, List args) =>
      new MkdirProcess(id, COMMAND, args);
}

class MkdirProcess extends Process {
  MkdirProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // TODO
    await output(new DivElement()..text='MkdirProcess.start()');
    exit(0);
  }
}
