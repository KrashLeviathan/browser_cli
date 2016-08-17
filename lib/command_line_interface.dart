library command_line_interface;

import 'dart:html';
import 'dart:async';

import 'package:hello_morpheus/environment_variables.dart';
import 'package:hello_morpheus/process_manager.dart';
import 'package:hello_morpheus/processes/authentication_process.dart';

part 'command_line_interface/key_binding_manager.dart';
part 'command_line_interface/key_gesture.dart';
part 'command_line_interface/parsed_input.dart';

class CommandLineInterface {
  DivElement get shell => querySelector('#shell');
  SpanElement get standardInput => querySelector('#standard-input');
  SpanElement get prompt => querySelector('#prompt');
  String get stdIn => standardInput.text;
  DivElement get lastOutput => querySelector('#last-output');

  String promptText = '~ user\$';

  final ProcessManager processManager = new ProcessManager();
  StreamSubscription processManagerOutputSubscription;
  StreamSubscription processManagerTriggerInputSubscription;

  bool _running = false;
  bool get running => _running;

  KeyBindingManager _keyBindingManager = new KeyBindingManager();

  CommandLineInterface() {
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

  _print(DivElement outputDiv) {
    lastOutput?.attributes?.remove('id');
    outputDiv..id = 'last-output'
      ..classes.add('output');
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
    var inputContainer = new DivElement()..className = 'input';
    var userInput = new SpanElement()
      ..id = 'standard-input'
      ..className = 'input'
      ..contentEditable = 'true';
    var prompt = new SpanElement()
      ..id = 'prompt'
      ..text = promptText;
    inputContainer.children..add(prompt)..add(userInput);
    shell.children.add(inputContainer);
    userInput.focus();
  }

  _addBindings() {
    _keyBindingManager.bindings[new KeyGesture(KeyCode.ENTER)] = _commitInput;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_C, ctrlKey: true)] =
        _sigint;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_N, ctrlKey: true)] =
        _nextLine;
    _keyBindingManager.bindings[new KeyGesture(KeyCode.KEY_P, ctrlKey: true)] =
        _previousLine;
  }

  _addEnvVars() {
    new EnvVars()
        ..set('TEST_VAR_1', 'foobar')
        ..set('HOME', 'is where the heart is');
  }

  bool _commitInput(KeyboardEvent event) {
    if (stdIn.endsWith(r'\')) {
      return false;
    }
    event.preventDefault();
    var parsedInput = new ParsedInput.fromString(stdIn);
    if (parsedInput != null) {
      processManager.startProcess(parsedInput.command, args: parsedInput.args);
    }
    return true;
  }

  bool _sigint(KeyboardEvent event) {
    print("handled Ctrl+C");
    return true;
  }

  bool _nextLine(KeyboardEvent event) {
    print("handled Ctrl+N");
    return true;
  }

  bool _previousLine(KeyboardEvent event) {
    print("handled Ctrl+P");
    return true;
  }

//  _setupBlinkingPrompt() {
//    HtmlElement prompt = querySelector('#prompt');
//    bool promptVisible = false;
//    Timer promptTimer = new Timer.periodic(new Duration(milliseconds: 500), (timer) {
//      if (promptVisible) {
//        prompt.className = "hidden";
//      } else {
//        prompt.className = "";
//      }
//      promptVisible = !promptVisible;
//    });
//  }
}
