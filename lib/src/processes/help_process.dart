library process.help;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/utils.dart';

class HelpProcessFactory extends ProcessFactory {
  static final String COMMAND = 'help';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  HelpProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  HelpProcess createProcess(int id, List args) =>
      new HelpProcess(id, COMMAND, args, this);
}

class HelpProcess extends Process {
  HelpProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (!args.isEmpty) {
      await _parseArgs();
    }
    await _displayCommands();
    exit(0);
  }

  _displayCommands() {
    var pm = new ProcessManager();
    var div = new DivElement()..setInnerHtml(pm.registeredCommands.toString());
//    div.className = '${CLI.VISIBLE_SCROLL} ${CLI.BORDERED_SCROLL_AREA}';
    output(div);
  }

  _parseArgs() {
    var div = new DivElement()
      ..text = "No arguments taken for $command command!";
    output(div);
  }
}
