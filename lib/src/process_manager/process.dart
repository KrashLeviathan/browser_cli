part of process_manager;

abstract class ProcessFactory {
  // static final String COMMAND;
  final String command;

  ProcessFactory(this.command);

  Process createProcess(int id, List args);
}

abstract class Process {
  final int id;
  final String command;
  final List args;
  final DateTime startTime = new DateTime.now();

  StreamController<String> _callCommandController = new StreamController();
  Stream<String> get callCommandStream => _callCommandController.stream;

  StreamController<String> _inputController = new StreamController();
  Stream<String> get inputStream => _inputController.stream;

  bool _inForeground = true;
  bool get inForeground => _inForeground;

  StreamController<HtmlElement> _outputStreamController = new StreamController();
  Stream<HtmlElement> get outputStream => _outputStreamController.stream;

  StreamController<bool> _requestForStdInStreamController =
      new StreamController();
  Stream<bool> get requestForStdInStream =>
      _requestForStdInStreamController.stream;

  StreamController<int> _exitCodeStreamController = new StreamController();
  Stream<int> get exitCodeStream => _exitCodeStreamController.stream;

  Process(this.id, this.command, this.args);

  Future start();

  // Override if necessary
  Future kill([String message]) async {
    await output(new DivElement()..text='Killed: $id $command');
  }

  output(DivElement div) => _outputStreamController.add(div);

  input(String str) => _inputController.add(str);

  requestInput() => _requestForStdInStreamController.add(null);

  exit(int code) => _exitCodeStreamController.add(code);

  Duration get runTime => startTime.difference(new DateTime.now());
}
