library process.man;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

// TODO: v2.0.0

class ManProcessFactory extends ProcessFactory {
  static final String COMMAND = 'man';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  ManProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  ManProcess createProcess(int id, List args) =>
      new ManProcess(id, COMMAND, args, this);
}

class ManProcess extends Process {
  ManProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    await output(new DivElement()..text = 'ManProcess.start()');
  }
}
