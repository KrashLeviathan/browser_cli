library process.help;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/utils.dart';

class HelpProcessFactory extends ProcessFactory {
  static final String COMMAND = 'help';
  static final String USAGE = 'USAGE: help [ [-l | --list] | <command> ]';
  static final String SHORT_DESCRIPTION =
      'Offers help information for the command line interface.';
  static final String LONG_DESCRIPTION = 'Offers help information for the '
      'command line interface. Typing `help [ -l | --list ]` will print '
      'all commands available to the user. Typing `help <command>` will give '
      'help information about the command.';

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
    } else {
      await _displayGeneralHelp();
    }
    exit(0);
  }

  void _displayGeneralHelp() {
    output(new DivElement()
      ..text = """
You're using browser_cli, a command line interface that runs in the browser!
To see a list of available commands, type `help --list`. To see help about
any command, type `help <command>`.
    """);
  }

  void _displayCommands() {
    var pm = new ProcessManager();
    var div = new DivElement();
    div.append(new ParagraphElement()..text = "Available commands:");

    var list = new UListElement();
    pm.registeredCommands.forEach((cmd) {
      list.append(new LIElement()..text = cmd);
    });
    div.append(list);

    if (pm.registeredCommands.length > 10) {
      div.className = '${CLI.VISIBLE_SCROLL} ${CLI.BORDERED_SCROLL_AREA}';
    }

    output(div);
  }

  void _displayCommandHelp(String command) {
    var processFactory =
        new ProcessManager().registeredProcessFactories[command];

    var div = new DivElement();
    div.append(new ParagraphElement()..innerHtml = "<b>$command</b>");
    div.append(new ParagraphElement()..text = processFactory.usage);
    div.append(new ParagraphElement()..text = processFactory.longDescription);

    output(div);
  }

  _parseArgs() {
    var pm = new ProcessManager();
    for (var i = 0; i < args.length; i++) {
      var arg = args[i];

      if (arg == "-l" || arg == "--list") {
        _displayCommands();
        return;
      }

      if (pm.registeredCommands.contains(arg)) {
        _displayCommandHelp(arg);
        return;
      }
    }

    output(new DivElement()..text = factory.usage);
  }
}
