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

/// Offers help information for the
/// command line interface. Typing `help [ -l | --list ]` will print
/// all commands available to the user. Typing `help <command>` will give
/// help information about the command.
class HelpProcess extends Process {
  HelpProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      await _parseArgs();
    } else {
      await _displayGeneralHelp();
    }
  }

  void _displayGeneralHelp() {
    var helpText = """
<p>You are using <b style='color: #9ccc7f; font-size: larger;'>browser_cli</b>,
a command line interface that runs in the browser!
To see a list of available commands, type <b>`help --list`</b> or <b>`commands`
</b>. To see help about any command, type <b>`help &lt;command&gt;`</b>.</p>

<p>A few helpful features you should know about:</p>
<ul>
  <li>Get command completion by using the TAB key. Future versions will include
      argument completion as well.</li>
  <li>Cycle through previous input history using UP and DOWN or, alternatively,
      ALT+P, ALT+N. (Sorry I couldn't use CTRL+P and CTRL+N -- browser
      restrictions reserve certain keybindings that can't be captured in
      Javascript!)</li>
  <li>Set temporary variables using <b>`myVar="Hello World!"`</b> format, or set
      persisting variables using the <b>`export`</b> command. Exported variables
      are stored in the cookies, so they will persist across browser sessions.
      Recall the value of a variable using <b>`&#36;myVar`</b>. Erase a variable
      using the <b>`unset`</b> command.</li>
</ul>

<p>More features will be coming in the future, so stay tuned!</p>
<p>This project is open source! Feel free to contribute -- the repository can be
   found at
   <a href='https://github.com/KrashLeviathan/browser_cli' target='_blank'>
   https://github.com/KrashLeviathan/browser_cli</a>.</p>
<p>Original creator: Nathan Karasch, Software Engineering Student at Iowa State
University</p>""";

    var validator = new NodeValidatorBuilder.common()
      ..allowNavigation(new _GithubUriPolicy())
      ..allowInlineStyles();

    output(new DivElement()..setInnerHtml(helpText, validator: validator));
  }

  void _listCommands() {
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
    var foundListParam = false;
    var commandsForWhichHelpWasRequested = new Set();

    for (var i = 0; i < args.length; i++) {
      var arg = args[i];
      if (arg == "-l" || arg == "--list") {
        foundListParam = true;
        continue;
      }
      if (pm.registeredCommands.contains(arg)) {
        commandsForWhichHelpWasRequested.add(arg);
        continue;
      }
      // Found something that shouldn't be there.
      output(new DivElement()..text = factory.usage);
      exit(1);
    }

    if (foundListParam) {
      _listCommands();
    }
    commandsForWhichHelpWasRequested.forEach((cmd) {
      _displayCommandHelp(cmd);
    });
  }
}

class _GithubUriPolicy implements UriPolicy {
  final AnchorElement _hiddenAnchor = new AnchorElement();

  bool allowsUri(String uri) {
    _hiddenAnchor.href = uri;
    return _hiddenAnchor.hostname == "github.com";
  }
}
