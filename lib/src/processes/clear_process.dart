library process.clear;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/command_line_interface.dart';
import 'package:browser_cli/process_manager.dart';

class ClearProcessFactory extends ProcessFactory {
  static final String COMMAND = 'clear';
  static final String USAGE = 'USAGE: clear';
  static final String SHORT_DESCRIPTION = 'Clears the command line interface.';
  static final String LONG_DESCRIPTION = 'Clears the command line interface.';

  ClearProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION, true,
            ProcessAccessibility.VERBOSE_VISIBLE);

  ClearProcess createProcess(int id, List args) =>
      new ClearProcess(id, COMMAND, args, this);
}

/// Clears the command line interface.
class ClearProcess extends Process {
  ClearProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      output(new DivElement()..text = factory.usage);
      exit(1);
    }
    new CommandLineInterface().shell.innerHtml = "";
  }
}
