library process.rm;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

// TODO: v2.0.0

class RmProcessFactory extends ProcessFactory {
  static final String COMMAND = 'rm';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  RmProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  RmProcess createProcess(int id, List args) =>
      new RmProcess(id, COMMAND, args, this);
}

class RmProcess extends Process {
  RmProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    await output(new DivElement()..text = 'RmProcess.start()');
  }
}
