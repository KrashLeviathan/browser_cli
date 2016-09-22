library process_manager;

import 'dart:async';
import 'dart:html';
import 'dart:math' show Random;

import 'package:browser_cli/utils.dart' as utils;

part 'src/process_manager/process.dart';

class ProcessManager {
  int _randSeed;
  int get randSeed => _randSeed;
  Random _rand;

  Map<int, Process> _processes = new Map();
  Map<int, Process> get processes => _processes;

  Map<int, StreamSubscription> _outputSubscriptions = new Map();

  StreamController<DivElement> _outputStreamController = new StreamController();
  Stream<DivElement> get onOutput => _outputStreamController.stream;

  StreamController<bool> _triggerInputStreamController = new StreamController();

  /// Indicates to the command line interface to get input from the user. If the value is `true`,
  /// the input is being requested by the process. If `false`, it is handled normally by the
  /// command line interface.
  Stream<bool> get onTriggerInput => _triggerInputStreamController.stream;

  Map<String, ProcessFactory> _registeredProcessFactories = new Map();

  ProcessManager({int randomizerSeed}) {
    _randSeed = randomizerSeed ?? new Random().nextInt(utils.MAX_INT);
    _rand = new Random(_randSeed);
  }

  bool startProcess(String command, {List args}) {
    var id = _generateId();
    var arguments = args ?? [];
    var process =
        _registeredProcessFactories[command]?.createProcess(id, arguments);
    if (process != null) {
      processes[id] = process;
      _outputSubscriptions[id] = process.outputStream.listen((output) {
        _handleProcessOutput(id, output);
      });
      process.start().then((_) {
        _triggerInputStreamController.add(false);
      });
      return true;
    } else {
      // TODO: Try throwing error instead...
      _outputStreamController.add(new DivElement()
        ..text = '$command: command not found'
        ..classes.add(utils.CLI.STDERR));
      _triggerInputStreamController.add(false);
      return false;
    }
  }

  bool killProcess(int processId) {
    if (processes.keys.contains(processId) && processes[processId] != null) {
      processes[processId].kill().then((_) {
        _triggerInputStreamController.add(false);
      });
      return true;
    } else {
      return false;
    }
  }

  bool bringToForeground(int processId) {
    // TODO
    return false;
  }

  bool sendToBackground(int processId) {
    // TODO
    return false;
  }

  registerProcessFactories(List<ProcessFactory> factories) {
    factories.forEach((factory) {
      _registeredProcessFactories[factory.command] = factory;
    });
  }

  _handleProcessOutput(int id, DivElement output) {
    if (processes[id].inForeground) {
      _outputStreamController.add(output);
    }
  }

  int _generateId() {
    var id = _rand.nextInt(utils.MAX_INT);
    var attempts = 0;
    while (processes.keys.contains(id)) {
      id = _rand.nextInt(utils.MAX_INT);
      if (attempts++ > 5000) {
        throw new Exception(
            'Too many attempts trying to create unique process id');
      }
    }
    return id;
  }
}
