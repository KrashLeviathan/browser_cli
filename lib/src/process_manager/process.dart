part of process_manager;

/// Used to create [Process] objects of a concrete type with the given command.
abstract class ProcessFactory {
  /// The command string used to start this process in the shell.
  final String command;

  /// A short usage summary. Example: "USAGE: jobs [-v | --verbose]"
  final String usage;

  /// A short description of what the [Process] does.
  final String shortDescription;

  /// A lengthier description of what the [Process] does.
  final String longDescription;

  /// If `true`, the processManager will automatically exit with code 0 once
  /// the start() method completes. If `false`, the process needs to make the
  /// exit(int) call manually.
  final bool autoExit;

  ProcessFactory(
      this.command, this.usage, this.shortDescription, this.longDescription,
      [this.autoExit = true]);

  /// Starts a [Process] of a concrete type with the given id and arguments.
  Process createProcess(int id, List args);
}

/// A [Process] is something that runs in the shell. It gets started with a
/// command typed into the shell. An implemented concrete [Process] is created
/// by it's corresponding [ProcessFactory].
abstract class Process {
  /// The process id.
  final int id;

  /// The command string used to start this process in the shell.
  final String command;

  /// The arguments passed into the process from the shell.
  final List args;

  /// The factory used to create this process.
  final ProcessFactory factory;

  /// The time the process started.
  final DateTime startTime = new DateTime.now();

  /// The time the process stopped.
  DateTime get stopTime => _stopTime;
  DateTime _stopTime;

  /// The [Stream] of commands this [Process] is trying to call from the shell.
  Stream<String> get callCommandStream => _callCommandController.stream;
  StreamController<String> _callCommandController = new StreamController();

  /// The [Stream] of all input that has been given to the [Process] since
  /// starting.
  Stream<String> get inputStream => _inputController.stream;
  StreamController<String> _inputController = new StreamController.broadcast();

  /// Returns `true` if this process is running in the foreground.
  bool get inForeground => _inForeground;
  bool _inForeground = true;

  /// Returns `true` if this process has completed, otherwise false.
  bool get completed => _completed;
  bool _completed = false;

  /// The [Stream] of [HtmlElement] objects that this [Process] wants to
  /// output. The output gets printed to the shell unless it is being piped
  /// elsewhere.
  Stream<HtmlElement> get outputStream => _outputStreamController.stream;
  StreamController<HtmlElement> _outputStreamController =
      new StreamController();

  /// If this [Process] wants to request the standard input from the shell,
  /// it adds to this [Stream].
  Stream<bool> get requestForStdInStream =>
      _requestForStdInStreamController.stream;
  StreamController<bool> _requestForStdInStreamController =
      new StreamController();

  /// This [Stream] only receives one event -- the exit code upon completion
  /// of the [Process]. Exit code `0` means the [Process] completed
  /// successfully.
  Stream<int> get exitCodeStream => _exitCodeStreamController.stream;
  StreamController<int> _exitCodeStreamController = new StreamController();

  Process(this.id, this.command, this.args, this.factory);

  /// Starts the [Process].
  Future start();

  /// Kills the [Process]. Override and implement for specific use cases.
  Future kill([String message = "", int exitCode = 1]) async {
    var appendedMessage = (message == null) ? "" : " -- ${message}";
    await output(
        new DivElement()..text = 'Killed: $id $command$appendedMessage');
    exit(exitCode);
  }

  /// Used by the [Process] to output things to the shell (or to wherever
  /// output is being piped).
  output(DivElement div) => _outputStreamController.add(div);

  /// Used by external parties to input [String] objects to the [Process].
  input(String str) => _inputController.add(str);

  /// Used by the [Process] to request standard input from the shell. It
  /// returns a [Future]<[String]> containing the response from the user.
  Future<String> requestInput() {
    Completer<String> completer = new Completer();
    StreamSubscription streamSub;
    streamSub = inputStream.listen((response) {
      completer.complete(response);
      streamSub.cancel();
      streamSub = null;
    });
    _requestForStdInStreamController.add(null);
    return completer.future;
  }

  /// Exits with the given exit code. Exit code `0` means the [Process]
  /// completed successfully. `exit(0)` will be called by default if no other
  /// exit code is given by the process, so most of the time you'll only use
  /// this command if you're exiting in an error status.
  exit(int code) {
    _completed = true;
    switch (code) {
      case 0:
        // Successful exit. The frame delay lets all output be printed to the
        // shell before exiting.
        new Future.delayed(Duration.ZERO).then((_) {
          _stopTime = new DateTime.now();
          _exitCodeStreamController.add(code);
        });
        return;
      default:
        // Exit in an error status. There is no frame delay, because an error
        // status exit should interrupt the process.
        _stopTime = new DateTime.now();
        _exitCodeStreamController.add(code);
        return;
    }
  }

  /// Returns the length of time the [Process] has been running (if not
  /// completed) or the time it ran (if already completed).
  Duration get runTime => (_completed)
      ? startTime.difference(stopTime)
      : startTime.difference(new DateTime.now());

  String toString() => "$id: $command $args $startTime";

  String toStringVerbose() =>
      "id: <b>$id</b><br>command: $command<br>args: $args<br>startTime: $startTime";
}
