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

  /// The most recent [Process] that was started.
  Process get mostRecent => _mostRecent;
  Process _mostRecent;

  /// The [Stream] of [DivElement] objects that should be output to the shell.
  Stream<DivElement> get onOutput => _outputStreamController.stream;
  Map<int, StreamSubscription> _outputSubscriptions = new Map();
  StreamController<DivElement> _outputStreamController = new StreamController();

  /// Indicates to the command line interface to get input from the user. If
  /// the value is an integer, the input is being requested by the process with
  /// that id. If the value is 'null', it gets handled normally by the command
  /// line interface. // TODO
  Stream<int> get onTriggerInput => _triggerInputStreamController.stream;
  StreamController<int> _triggerInputStreamController = new StreamController();
  Map<int, StreamSubscription> _inputRequestStreamSubscriptions = new Map();

  /// A [List] of all commands that have been registered with the
  /// [ProcessManager].
  List<String> get registeredCommands => _registeredProcessFactories.keys;

  /// A [Map] of all [ProcessFactory] objects that have been registered with
  /// the [ProcessManager]. The keys in the map are the command names.
  Map<String, ProcessFactory> get registeredProcessFactories =>
      _registeredProcessFactories;
  Map<String, ProcessFactory> _registeredProcessFactories = new Map();

  /// Starts a process in the shell.
  bool startProcess(String command, {List args}) {
    try {
      var id = _generateId();
      var arguments = args ?? [];
      var process =
          _registeredProcessFactories[command]?.createProcess(id, arguments);
      if (process == null) {
        throw new Exception('$command: command not found');
      }
      processes[id] = process;
      _setupProcessListeners(process);
      _mostRecent = process;
      process.start();
      if (process.factory.autoExit) {
        process.exit(0);
      }
      return true;
    } catch (exception) {
      _outputStreamController.add(new DivElement()
        ..text = exception.toString()
        ..className = utils.CLI.STDERR);
      return false;
    }
  }

  /// Kills a running process
  bool killProcess(int processId) {
    if (processes.keys.contains(processId) && processes[processId] != null) {
      processes[processId].kill().then((_) {
        _cleanupFinishedProcess(processId);
        _triggerInputStreamController.add(null);
      });
      return true;
    } else {
      return false;
    }
  }

  /// Sends input `str` to the process indicated by `processId`. Returns `true`
  /// if the id refers to a valid process, otherwise returns `false`.
  bool input(int processId, String str) {
    if (processes.containsKey(processId)) {
      processes[processId].input(str);
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
    _inputRequestStreamSubscriptions[id] =
        process.requestForStdInStream.listen((_) {
      _triggerInputStreamController.add(id);
    });
    _processExitCodeStreamSubscriptions[id] =
        process.exitCodeStream.listen((code) {
      if (code != 0) {
        _handleProcessOutput(
            id,
            new DivElement()
              ..text = "exit($code)"
              ..className = utils.CLI.STDERR);
      }
      _cleanupFinishedProcess(id);

      // Ensures the error code exit message is displayed
      new Future.delayed(Duration.ZERO).then((_) {
        _triggerInputStreamController.add(null);
      });
    });
  }

  void _cleanupFinishedProcess(int id) {
    _processes.remove(id);
    _cleanupSubscription(_outputSubscriptions, id);
    _cleanupSubscription(_inputRequestStreamSubscriptions, id);
    _cleanupSubscription(_processExitCodeStreamSubscriptions, id);
  }

  void _cleanupSubscription(Map<int, StreamSubscription> map, int id) {
    map[id].cancel();
    map[id] = null;
    map.remove(id);
  }
}
