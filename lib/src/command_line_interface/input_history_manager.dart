part of command_line_interface;

/// Manages user input history, so a user can easily move back through
/// previously-typed commands in the shell.
class InputHistoryManager {
  List<String> _inputHistory = [""];
  int _index = 0;

  /// Inserts an input [String] in the history list at the current index,
  /// deleting everything after it.
  void add(String input) {
    _inputHistory.insert(_index, input);
    _index++;
    _inputHistory = _inputHistory.sublist(0, _index);
    _inputHistory.add("");
  }

  /// Returns an older input [String] each time until it reaches the beginning.
  String getPrevious() {
    if (_index > 0) {
      _index--;
    }
    return _inputHistory[_index];
  }

  /// Returns a newer input [String] each time until it reaches the end.
  String getNext() {
    if (_index < _inputHistory.length - 1) {
      _index++;
    }
    return _inputHistory[_index];
  }
}
