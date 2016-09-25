library process.testinput;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class TestInputProcessFactory extends ProcessFactory {
  static final String COMMAND = 'testinput';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  TestInputProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  TestInputProcess createProcess(int id, List args) =>
      new TestInputProcess(id, COMMAND, args, this);
}

class TestInputProcess extends Process {
  TestInputProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    await _startSync();
  }

  _startSync() {
    output(new DivElement()..text = 'Hello World! What is your name?');
    StreamSubscription streamSub;
    streamSub = inputStream.listen((str) {
      output(new DivElement()..text = 'Super! Nice to meet you ${str}.');
      streamSub.cancel();
      streamSub = null;
    });
    requestInput();
  }
}
