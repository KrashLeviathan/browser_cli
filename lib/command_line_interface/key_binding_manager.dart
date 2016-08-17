part of command_line_interface;

typedef bool KeyboardEventHandler(KeyboardEvent event);

class KeyBindingManager {
  Map<KeyGesture, KeyboardEventHandler> bindings = new Map();
  StreamSubscription windowOnKeyDownSubscription;
  bool _active = false;
  bool get active => _active;

  KeyBindingManager() {
    initialize();
  }

  activate() => _active = true;

  deactivate() => _active = false;

  initialize() {
    windowOnKeyDownSubscription = window.onKeyDown.listen(_handleKeyDown);
  }

  dispose() {
    _active = false;
    windowOnKeyDownSubscription?.cancel();
    windowOnKeyDownSubscription = null;
  }

  _handleKeyDown(KeyboardEvent event) {
    if (!active) return;
    querySelector('#standard-input')?.focus();
    bindings.keys.where((gesture) => gesture.matches(event)).forEach((gesture) {
      if (bindings[gesture](event)) return;
    });
  }
}
