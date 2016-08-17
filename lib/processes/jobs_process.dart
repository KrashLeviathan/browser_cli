library process.jobs;

import 'dart:async';
import 'dart:html';

import 'package:hello_morpheus/process_manager.dart';

class JobsProcessFactory extends ProcessFactory {
  static final String COMMAND = 'jobs';

  JobsProcessFactory() : super(COMMAND);

  JobsProcess createProcess(int id, List args) =>
      new JobsProcess(id, COMMAND, args);
}

class JobsProcess extends Process {
  JobsProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // TODO
    await output(new DivElement()..text='JobsProcess.start()');
    exit(0);
  }
}
