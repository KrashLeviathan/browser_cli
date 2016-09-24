library process_manager;

import 'dart:async';
import 'dart:html';
import 'dart:math' show Random;

import 'package:browser_cli/utils.dart' as utils;

part 'src/process_manager/process.dart';

/// Manages the starting, stopping, and manipulation of all processes in the
/// shell.
class ProcessManager {
  static ProcessManager _processManagerSingleton;

  // Runs the first time the singleton is constructed.
  ProcessManager._internal(int randomizerSeed) {
    _randSeed = randomizerSeed ?? new Random().nextInt(utils.MAX_INT);
    _rand = new Random(_randSeed);
    _processManagerSingleton = this;
  }

  /// Will always return the same singleton [CommandLineInterface] object.
  /// The randomizerSeed argument only gets processed the first time the
  /// singleton is created.
  factory ProcessManager({int randomizerSeed}) =>
      (_processManagerSingleton == null)
          ? new ProcessManager._internal(randomizerSeed)
          : _processManagerSingleton;

  /// The randomizer seed for all pseudo-random operations.
  int get randSeed => _randSeed;
  Random _rand;
  int _randSeed;

  /// A [Map] of all processes that are currently running, with the key being
  /// the process id.
  Map<int, Process> get processes => _processes;
  Map<int, Process> _processes = new Map();
  Map<int, StreamSubscription> _processExitCodeStreamSubscriptions = new Map();

  /// The [Stream] of [DivElement] objects that should be output to the shell.
  Stream<DivElement> get onOutput => _outputStreamController.stream;
  Map<int, StreamSubscription> _outputSubscriptions = new Map();
  StreamController<DivElement> _outputStreamController = new StreamController();

  /// Indicates to the command line interface to get input from the user. If
  /// the value is `true`, the input is being requested by the process. If
  /// `false`, it is handled normally by the command line interface.
  Stream<bool> get onTriggerInput => _triggerInputStreamController.stream;
  StreamController<bool> _triggerInputStreamController = new StreamController();

  List<String> get registeredCommands => _registeredProcessFactories.keys;
  Map<String, ProcessFactory> _registeredProcessFactories = new Map();

  /// Starts a process in the shell.
  bool startProcess(String command, {List args}) {
    var id = _generateId();
    var arguments = args ?? [];
    var process =
        _registeredProcessFactories[command]?.createProcess(id, arguments);
    if (process == null) {
      throw new Exception('$command: command not found');
    }
    processes[id] = process;
    _setupProcessListeners(process);
    process.start();
    return true;
  }

  /// Kills a running process
  bool killProcess(int processId) {
    if (processes.keys.contains(processId) && processes[processId] != null) {
      processes[processId].kill().then((_) {
        _cleanupFinishedProcess(processId);
        _triggerInputStreamController.add(false);
      });
      return true;
    } else {
      return false;
    }
  }

//  bool bringToForeground(int processId) {
//    // TODO v2.0.0
//    return false;
//  }

//  bool sendToBackground(int processId) {
//    // TODO: v2.0.0
//    return false;
//  }

  /// Used to register every type of process that can be started in the shell.
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

  void _setupProcessListeners(Process process) {
    var id = process.id;
    _outputSubscriptions[id] = process.outputStream.listen((output) {
      _handleProcessOutput(id, output);
    });
    _processExitCodeStreamSubscriptions[id] =
        process.exitCodeStream.listen((code) {
      if (code != 0) {
        _handleProcessOutput(
            id,
            new DivElement()
              ..text = "Exited with code $code."
              ..className = utils.CLI.STDERR);
      }
      _cleanupFinishedProcess(id);
      _triggerInputStreamController.add(false);
    });
  }

  void _cleanupFinishedProcess(int id) {
    _processes.remove(id);
    _outputSubscriptions[id].cancel();
    _outputSubscriptions[id] = null;
    _outputSubscriptions.remove(id);
    _processExitCodeStreamSubscriptions[id].cancel();
    _processExitCodeStreamSubscriptions[id] = null;
    _processExitCodeStreamSubscriptions.remove(id);
  }
}
