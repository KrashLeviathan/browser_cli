library process.testinput;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/command_line_interface.dart' show ParsedInput;
import 'package:browser_cli/process_manager.dart';

class TestInputProcessFactory extends ProcessFactory {
  static final String COMMAND = 'testinput';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';
  static final bool AUTO_EXIT = false;

  TestInputProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, AUTO_EXIT);

  TestInputProcess createProcess(int id, List args) =>
      new TestInputProcess(id, COMMAND, args, this);
}

class TestInputProcess extends Process {
  TestInputProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    await output(new DivElement()
      ..text = 'This is an example of a process that accepts user input! '
          'It also demonstrates how to call other processes from within a '
          'process, which can be used later for piping. Type something...');

    var response = "";
    while (response != 'exit') {
      response = await requestInput();
      if (response.startsWith('callCommand ')) {
        var parsedInput = new ParsedInput.fromString(response.substring(12));
        new ProcessManager()
            .startProcess(parsedInput.command, args: parsedInput.args);
      }
      output(new DivElement()
        ..text = 'You typed `${response}`. '
            'Type `callCommand <command>` to call a command programmatically '
            'from this process or `exit` to exit this process.');
    }
    exit(0);
  }
}
