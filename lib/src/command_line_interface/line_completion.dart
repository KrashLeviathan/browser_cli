part of command_line_interface;

class LineCompletion {
  /// The singleton [CommandLineInterface].
  static CommandLineInterface get cli => new CommandLineInterface();

  /// Completes a partial command typed into the shell.
  static void completeCommand(String command) {
    var matches = [];
    cli.processManager.registeredCommands.forEach((pmCommand) {
      if (pmCommand.startsWith(command)) {
        matches.add(pmCommand);
      }
    });

    supplementaryCommandMappings.keys.forEach((suppCommand) {
      if (suppCommand.startsWith(command)) {
        matches.add(suppCommand);
      }
    });

    if (matches.isEmpty) {
      return;
    }

    if (matches.length == 1) {
      cli.standardInput.text = "${matches[0]} ";
      cli.setSelectionToEnd();
      return;
    }

    if (cli._keyBindingManager.consecutiveTabPresses > 1) {
      _showCompletionOptions(command, matches);
    }
  }

  static void _showCompletionOptions(String command, List<String> matches) {
    var done = false;
    var index = 0;
    var partialCommand = "";

    while (!done) {
      // Get character from first match
      if (index >= matches[0].length) {
        done = true;
        break;
      }
      var character = matches[0][index];

      // Compare with characters from the other matches, seeing if they're all
      // the same.
      for (var m = 1; m < matches.length; m++) {
        if (index >= matches[m].length || matches[m][index] != character) {
          done = true;
          break;
        }
      }

      // If the character at `index` from all the matches was the same, we're
      // not done and keep looping through the matches at the next character
      // index.
      if (!done) {
        partialCommand += character;
        index++;
      }
    }

    cli.standardInput.text = partialCommand;
    cli.setSelectionToEnd();
    _outputCompletionOptions(matches);
  }

  static void _outputCompletionOptions(List<String> matches) {
    var div = new DivElement();
    var uList = new UListElement();
    matches.forEach((match) {
      uList.append(new LIElement()..text = match);
    });
    div.append(uList);
    cli._print(div);
  }

  /// Completes a partial argument typed into the shell
  static void completeArgument(List<String> args) {
    // TODO - Line Completion for Arguments
  }
}
