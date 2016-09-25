library process.cd;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

// TODO: v2.0.0

class CdProcessFactory extends ProcessFactory {
  static final String COMMAND = 'cd';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  CdProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  CdProcess createProcess(int id, List args) =>
      new CdProcess(id, COMMAND, args, this);
}

class CdProcess extends Process {
  CdProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    // TODO
    await output(new DivElement()..text = 'CdProcess.start()');
  }
}
