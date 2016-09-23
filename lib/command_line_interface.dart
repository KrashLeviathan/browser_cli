library command_line_interface;

import 'dart:html';
import 'dart:async';

import 'package:browser_cli/environment_variables.dart';
import 'package:browser_cli/process_manager.dart';
import 'package:browser_cli/src/processes/authentication_process.dart';
import 'package:browser_cli/utils.dart';

part 'src/command_line_interface/key_binding_manager.dart';
part 'src/command_line_interface/key_gesture.dart';
part 'src/command_line_interface/parsed_input.dart';

/// The main GUI command line interface that the user interacts with.
class CommandLineInterface {
  static CommandLineInterface _commandLineInterfaceSingleton;

  // Runs the first time the singleton is constructed.
  CommandLineInterface._internal() {
    _commandLineInterfaceSingleton = this;
    promptText = standardPromptText;
    _addBindings();
    _addEnvVars();
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
        processManager.onTriggerInput.listen((_) {
      if (running) {
        _triggerInput();
      }
    });
  }

  /// Stops the CLI, disabling user interaction and process output temporarily.
  /// The CLI can be started again from this state by calling start().
  stop() {
    _running = false;
    _keyBindingManager.deactivate();
    // TODO
  }

  /// Stops the CLI permanently. It cannot be started again using the start()
  /// method. The kill() method is used when you want to dispose of browser
  /// resources being used by the CommandLineInterface.
  kill() {
    _running = false;
    _startable = false;
    _keyBindingManager.dispose();
    // TODO
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

  _triggerInput() {
    if (!running) {
      return;
    }
    if (standardInput != null) {
      var previousStdIn = this.prompt.text + ' ' + stdIn;
      var inputContainer = standardInput.parent;
      this.prompt.remove();
      standardInput.remove();
      inputContainer.text = previousStdIn;
    }
    var inputContainer = new DivElement()..className = CLI.INPUT;
    var userInput = new SpanElement()
      ..id = CLI.STANDARD_INPUT
      ..className = CLI.INPUT
      ..contentEditable = 'true';
    var prompt = new SpanElement()
      ..id = CLI.PROMPT
      ..text = promptText;
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
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_N, ctrlKey: true)] =
        _nextLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.UP_ARROW)] =
        _previousLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_P, ctrlKey: true)] =
        _previousLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.TAB)] = _lineCompletion;
  }

  _addEnvVars() {
    new EnvVars()
      ..set(
          'PATH',
          '"Do not go where the path may lead, go instead where '
          'there is no path and leave a trail." - Ralph Waldo Emerson')
      ..set(
          'HOME',
          '"Home is the place where, when you have to go there, '
          'they have to take you in." - Robert Frost');
  }

  bool _commitInput(KeyboardEvent event) {
    try {
      if (stdIn.endsWith(r'\')) {
        return false;
      }
      event.stopImmediatePropagation();
      event.preventDefault();
      var parsedInput = new ParsedInput.fromString(stdIn);
      if (parsedInput != null) {
        processManager.startProcess(parsedInput.command,
            args: parsedInput.args);
      }
      return true;
    } catch (exception) {
      _print(new DivElement()..text = exception.toString(), stderr: true);
      _triggerInput();
      return true;
    }
  }

  bool _sigint(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    // TODO
    print("handled Ctrl+C");
    return true;
  }

  bool _nextLine(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    // TODO
    print("handled _nextLine KeyGesture");
    return true;
  }

  bool _previousLine(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    // TODO
    print("handled _previousLine KeyGesture");
    return true;
  }

  bool _lineCompletion(KeyboardEvent event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    // TODO
    print("handled _lineCompletion KeyGesture");
    return true;
  }
}
