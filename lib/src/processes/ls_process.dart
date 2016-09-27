library process.ls;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

// TODO: v2.0.0

class LsProcessFactory extends ProcessFactory {
  static final String COMMAND = 'ls';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  LsProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  LsProcess createProcess(int id, List args) =>
      new LsProcess(id, COMMAND, args, this);
}

class LsProcess extends Process {
  LsProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    await output(new DivElement()..text = 'LsProcess.start()');
  }
}
