library process.testinput;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class TestInputProcessFactory extends ProcessFactory {
  static final String COMMAND = 'testinput';

  TestInputProcessFactory() : super(COMMAND);

  TestInputProcess createProcess(int id, List args) =>
      new TestInputProcess(id, COMMAND, args);
}

class TestInputProcess extends Process {
  TestInputProcess(int id, String command, List args)
      : super(id, command, args);

  Future start() async {
    await _startSync();
    exit(0);
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
