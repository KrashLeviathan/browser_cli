/**
 * This library provides the main interface between the user and the
 * application. It receives input from the user, parses input, displays
 * output to the user, and deals with other elements of user interaction.
 */
library command_line_interface;

import 'dart:html';
import 'dart:async';

import 'package:browser_cli/environment_variables.dart';
import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/src/processes/authentication_process.dart';
import 'package:browser_cli/utils.dart';

part 'src/command_line_interface/line_completion.dart';
part 'src/command_line_interface/input_history_manager.dart';
part 'src/command_line_interface/key_binding_manager.dart';
part 'src/command_line_interface/key_gesture.dart';

/// The main GUI command line interface that the user interacts with.
class CommandLineInterface {
  static CommandLineInterface _commandLineInterfaceSingleton;

  // Runs the first time the singleton is constructed.
  CommandLineInterface._internal() {
    _commandLineInterfaceSingleton = this;
    promptText = standardPromptText;
    _addBindings();
    start();
    processManager
        .registerProcessFactories([new AuthenticationProcessFactory()]);
    processManager.startProcess(AuthenticationProcessFactory.COMMAND);
  }

  /// Will always return the same singleton [CommandLineInterface] object.
  factory CommandLineInterface() => (_commandLineInterfaceSingleton == null)
      ? new CommandLineInterface._internal()
      : _commandLineInterfaceSingleton;

  /// The container for the CLI shell.
  DivElement get shell => querySelector('#${CLI.SHELL}');

  /// The element that captures user input.
  SpanElement get standardInput => querySelector('#${CLI.STANDARD_INPUT}');

  /// The leading bit of text before the standard input.
  SpanElement get prompt => querySelector('#${CLI.PROMPT}');

  /// The active [String] of text that the user has entered.
  String get stdIn => standardInput.text;

  /// The last element that was output to the shell.
  DivElement get lastOutput => querySelector('#${CLI.LAST_OUTPUT}');

  /// The [String] that makes up the leading bit of text before the standard
  /// input.
  String promptText;

  /// Manages the starting, stopping, and manipulation for all processes in
  /// this [CommandLineInterface]
  final ProcessManager processManager = new ProcessManager();
  StreamSubscription _processManagerOutputSubscription;
  StreamSubscription _processManagerTriggerInputSubscription;

  /// `true` if the CLI is running, otherwise `false`. Whether or not the CLI is
  /// running determines whether user input is captured and other things.
  bool get running => _running;
  bool _running = false;
  bool _startable = true;

  KeyBindingManager _keyBindingManager = new KeyBindingManager();
  InputHistoryManager _inputHistoryManager = new InputHistoryManager();

  /// Starts the CLI, enabling it to capture user input and be interacted with.
  start() {
    if (!_startable) {
      throw new Exception("The CommandLineInterface cannot be started again!");
    }
    _running = true;
    _keyBindingManager.activate();
    _processManagerOutputSubscription =
        processManager.onOutput.listen((output) {
      if (running) {
        _print(output);
      }
    });
    _processManagerTriggerInputSubscription =
        processManager.onTriggerInput.listen((processId) {
      if (running) {
        _triggerInput(processId);
      }
    });
  }

  /// Stops the CLI, disabling user interaction and process output temporarily.
  /// The CLI can be started again from this state by calling start().
  stop() {
    _running = false;
    _keyBindingManager.deactivate();
    // TODO - Stopping the CLI
  }

  /// Stops the CLI permanently. It cannot be started again using the start()
  /// method. The kill() method is used when you want to dispose of browser
  /// resources being used by the CommandLineInterface.
  kill() {
    _running = false;
    _startable = false;
    _keyBindingManager.dispose();
    // TODO - Killing the CLI
  }

  _print(DivElement outputDiv, {stderr: false}) {
    lastOutput?.attributes?.remove('id');
    outputDiv
      ..id = CLI.LAST_OUTPUT
      ..classes.add(CLI.OUTPUT);
    if (stderr) {
      outputDiv.classes.add(CLI.STDERR);
    }
    shell.children.add(outputDiv);
  }

  _triggerInput([int processId = null]) {
    if (!running) {
      return;
    }

    // Make modifications for input intended for a certain process
    var inputClass, modifiedPromptText;
    if (processId == null) {
      inputClass = CLI.INPUT;
      modifiedPromptText = promptText;
    } else {
      inputClass = '${CLI.INPUT_FOR_PROCESS} $processId';
      modifiedPromptText =
          '$processId ${processManager.processes[processId].command}\$';
    }

    // Update old StdIn div to new StdIn div
    if (standardInput != null) {
      var previousStdIn = this.prompt.text + ' ' + standardInput.innerHtml;
      var inputContainer = standardInput.parent;
      this.prompt.remove();
      standardInput.remove();
      inputContainer.innerHtml = previousStdIn;
    }

    var inputContainer = new DivElement()..className = inputClass;
    var userInput = new SpanElement()
      ..id = CLI.STANDARD_INPUT
      ..className = inputClass
      ..contentEditable = 'true';
    var prompt = new SpanElement()
      ..id = CLI.PROMPT
      ..text = modifiedPromptText;
    inputContainer.children..add(prompt)..add(userInput);
    shell.children.add(inputContainer);
    userInput.focus();
  }

  _addBindings() {
    // NOTE: Not all browsers allow all KeyGestures to be captured. Like in
    //       Chrome, you can't capture Ctrl+N, Ctrl+T, or Ctrl+W.
    _keyBindingManager.bindings[new KeyGesture(KeyCode.ENTER)] = _commitInput;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_C, ctrlKey: true)] =
        _sigint;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.DOWN_ARROW)] = _nextLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_N, altKey: true)] =
        _nextLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.UP_ARROW)] =
        _previousLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_P, altKey: true)] =
        _previousLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.TAB)] = _lineCompletion;
  }

  bool _commitInput(KeyboardEvent event) {
    try {
      // Check for input that wants to include the newline character
      if (stdIn.endsWith(r'\')) {
        return false;
      }
      var stdInString = standardInput.innerHtml
          .replaceAll(r'\<br>', '')
          .replaceAll(r'<br>', '')
          .replaceAll(nonBreakingLineSpace, ' ');
      event.stopImmediatePropagation();
      event.preventDefault();
      // Check to see if the input is a variable assignment (non-persisting)
      if (EnvVars.variableGetsAssigned(stdInString)) {
        _triggerInput();
        return true;
      }
      _inputHistoryManager.add(stdInString);
      var parsedInput = new ParsedInput.fromString(stdInString);
      _handleParsedInput(parsedInput);
    } catch (exception) {
      _print(new DivElement()..text = exception.toString(), stderr: true);
      _triggerInput();
    }

    return true;
  }

  void _handleParsedInput(ParsedInput input) {
    if (input != null) {
      if (standardInput.classes.contains(CLI.INPUT)) {
        processManager.startProcess(input.command,
            args: _preProcessArgs(input.args));
      } else if (standardInput.classes.contains(CLI.INPUT_FOR_PROCESS)) {
        var processId = standardInput.classes.firstWhere(
            (className) => int.parse(className, onError: (_) => 0) != 0);
        processManager.input(int.parse(processId, onError: (_) => 0), stdIn);
      }
    }
  }

  bool _sigint(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    _print(new DivElement()..text = "^C");
    processManager.killProcess(processManager.mostRecent.id);
    return true;
  }

  bool _nextLine(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    standardInput.text = _inputHistoryManager.getNext();
    setSelectionToEnd();
    return true;
  }

  bool _previousLine(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    standardInput.text = _inputHistoryManager.getPrevious();
    setSelectionToEnd();
    return true;
  }

  void setSelectionToEnd() {
    if (stdIn.length == 0) {
      return;
    }
    var range = document.createRange();
    var selection = window.getSelection();
    range.setStart(standardInput.childNodes[0], stdIn.length);
    range.collapse(true);
    selection.removeAllRanges();
    selection.addRange(range);
  }

  bool _lineCompletion(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    var parsedInput = new ParsedInput.fromString(stdIn);
    if (parsedInput != null) {
      if (parsedInput.args.isEmpty) {
        LineCompletion.completeCommand(parsedInput.command);
      } else {
        LineCompletion.completeArgument(parsedInput.args);
      }
    }
    return true;
  }

  List<String> _preProcessArgs(List<String> args) {
    var processedArgs = [];
    args.forEach((arg) {
      processedArgs
          .add(EnvVars.replaceMatchesWithEnvVars(arg, EnvVars.recallRegExp));
    });
    return processedArgs;
  }
}
