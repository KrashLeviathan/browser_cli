library process.echo;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/utils.dart';

class EchoProcessFactory extends ProcessFactory {
  static final String COMMAND = 'echo';
  static final String USAGE = 'USAGE: echo <string>';
  static final String SHORT_DESCRIPTION =
      'Prints the supplied input back to the shell.';
  static final String LONG_DESCRIPTION =
      'Prints the supplied input back to the shell';

  EchoProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  EchoProcess createProcess(int id, List args) =>
      new EchoProcess(id, COMMAND, args, this);
}

/// Prints the supplied input back to the shell.
class EchoProcess extends Process {
  EchoProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      await output(new DivElement()..text = args.join(' '));
    } else {
      await output(new DivElement()..innerHtml = nonBreakingLineSpace);
    }
  }
}
