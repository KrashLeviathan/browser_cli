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

class CommandLineInterface {
  DivElement get shell => querySelector('#${CLI.SHELL}');
  SpanElement get standardInput => querySelector('#${CLI.STANDARD_INPUT}');
  SpanElement get prompt => querySelector('#${CLI.PROMPT}');
  String get stdIn => standardInput.text;
  DivElement get lastOutput => querySelector('#${CLI.LAST_OUTPUT}');

  String promptText;

  final ProcessManager processManager = new ProcessManager();
  StreamSubscription processManagerOutputSubscription;
  StreamSubscription processManagerTriggerInputSubscription;

  bool _running = false;
  bool get running => _running;

  KeyBindingManager _keyBindingManager = new KeyBindingManager();

  CommandLineInterface({prompt: standardPromptText}) {
    promptText = prompt;
    _addBindings();
    _addEnvVars();
    start();
    processManager
        .registerProcessFactories([new AuthenticationProcessFactory()]);
    processManager.startProcess(AuthenticationProcessFactory.COMMAND);
  }

  start() {
    _running = true;
    _keyBindingManager.activate();
    processManagerOutputSubscription = processManager.onOutput.listen((output) {
      if (running) {
        _print(output);
      }
    });
    processManagerTriggerInputSubscription =
        processManager.onTriggerInput.listen((_) {
      if (running) {
        _triggerInput();
      }
    });
  }

  stop() {
    _running = false;
    _keyBindingManager.deactivate();
    // TODO
  }

  kill() {
    _running = false;
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
      event.preventDefault();
      var parsedInput = new ParsedInput.fromString(stdIn);
      if (parsedInput != null) {
        processManager.startProcess(parsedInput.command,
            args: parsedInput.args);
      }
      return true;
    } catch (exception) {
      _print(new DivElement()..text = exception.toString(), stderr: true);
      return true;
    }
  }

  bool _sigint(KeyboardEvent event) {
    print("handled Ctrl+C");
    return true;
  }

  bool _nextLine(KeyboardEvent event) {
    print("handled _nextLine KeyGesture");
    return true;
  }

  bool _previousLine(KeyboardEvent event) {
    print("handled _previousLine KeyGesture");
    return true;
  }
}
