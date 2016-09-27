library process.mkdir;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

// TODO: v2.0.0

class MkdirProcessFactory extends ProcessFactory {
  static final String COMMAND = 'mkdir';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  MkdirProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  MkdirProcess createProcess(int id, List args) =>
      new MkdirProcess(id, COMMAND, args, this);
}

class MkdirProcess extends Process {
  MkdirProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    await output(new DivElement()..text = 'MkdirProcess.start()');
  }
}
