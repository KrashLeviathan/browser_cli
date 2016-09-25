part of command_line_interface;

/// Defines a combination of keystrokes input by the user.
class KeyGesture {
  /// The javascript character key code, defined in [KeyCode] variables.
  int keyCode;

  /// Indicates the Control key was held during this [KeyGesture].
  bool ctrlKey;

  /// Indicates the Meta (Command on Mac) key was held during this [KeyGesture].
  bool metaKey;

  /// Indicates the Alt key was held during this [KeyGesture].
  bool altKey;

  /// Indicates the Shift key was held during this [KeyGesture].
  bool shiftKey;

  /// Constructs a [KeyGesture] with the given [keyCode]. If no optional
  /// parameters are passed, it assumes none of the helper keys (i.e. Ctrl,
  /// Alt, etc) were held during the gesture.
  KeyGesture(this.keyCode,
      {this.ctrlKey: false,
      this.metaKey: false,
      this.altKey: false,
      this.shiftKey: false});

  /// Returns whether the [KeyGesture] matches the gesture from the given
  /// [KeyboardEvent].
  bool matches(KeyboardEvent o) => (keyCode == o.keyCode &&
      ctrlKey == o.ctrlKey &&
      metaKey == o.metaKey &&
      altKey == o.altKey &&
      shiftKey == o.shiftKey);

  /// Returns whether the [KeyGesture] equals another gesture with the same
  /// key code and modifier keys.
  bool operator ==(KeyGesture o) => (keyCode == o.keyCode &&
      ctrlKey == o.ctrlKey &&
      metaKey == o.metaKey &&
      altKey == o.altKey &&
      shiftKey == o.shiftKey);
}

/// The javascript character key codes for keyboard button strokes
/// https://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
class KeyCode {
  static const int BACKSPACE = 8;
  static const int TAB = 9;
  static const int ENTER = 13;
  static const int SHIFT = 16;
  static const int CTRL = 17;
  static const int ALT = 18;
  static const int PAUSE_BREAK = 19;
  static const int CAPS_LOCK = 20;
  static const int ESCAPE = 27;
  static const int PAGE_UP = 33;
  static const int PAGE_DOWN = 34;
  static const int END = 35;
  static const int HOME = 36;
  static const int LEFT_ARROW = 37;
  static const int UP_ARROW = 38;
  static const int RIGHT_ARROW = 39;
  static const int DOWN_ARROW = 40;
  static const int INSERT = 45;
  static const int DELETE = 46;
  static const int KEY_C = 67;
  static const int KEY_N = 78;
  static const int KEY_P = 80;
  static const int LEFT_WIN_KEY = 91;
  static const int RIGHT_WIN_KEY = 92;
  static const int SELECT_KEY = 93;
  static const int NUMPAD_0 = 96;
  static const int NUMPAD_1 = 97;
  static const int NUMPAD_2 = 98;
  static const int NUMPAD_3 = 99;
  static const int NUMPAD_4 = 100;
  static const int NUMPAD_5 = 101;
  static const int NUMPAD_6 = 102;
  static const int NUMPAD_7 = 103;
  static const int NUMPAD_8 = 104;
  static const int NUMPAD_9 = 105;
}
