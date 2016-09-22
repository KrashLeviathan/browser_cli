part of command_line_interface;

class KeyGesture {
  int keyCode;
  bool ctrlKey;
  bool metaKey;
  bool altKey;
  bool shiftKey;

  KeyGesture(this.keyCode,
      {this.ctrlKey: false,
      this.metaKey: false,
      this.altKey: false,
      this.shiftKey: false});

  bool matches(KeyboardEvent o) => (keyCode == o.keyCode &&
      ctrlKey == o.ctrlKey &&
      metaKey == o.metaKey &&
      altKey == o.altKey &&
      shiftKey == o.shiftKey);
}

// https://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
class KeyCode {
  static int BACKSPACE = 8;
  static int TAB = 9;
  static int ENTER = 13;
  static int SHIFT = 16;
  static int CTRL = 17;
  static int ALT = 18;
  static int PAUSE_BREAK = 19;
  static int CAPS_LOCK = 20;
  static int ESCAPE = 27;
  static int PAGE_UP = 33;
  static int PAGE_DOWN = 34;
  static int END = 35;
  static int HOME = 36;
  static int LEFT_ARROW = 37;
  static int UP_ARROW = 38;
  static int RIGHT_ARROW = 39;
  static int DOWN_ARROW = 40;
  static int INSERT = 45;
  static int DELETE = 46;
  static int KEY_C = 67;
  static int KEY_N = 78;
  static int KEY_P = 80;
  static int LEFT_WIN_KEY = 91;
  static int RIGHT_WIN_KEY = 92;
  static int SELECT_KEY = 93;
  static int NUMPAD_0 = 96;
  static int NUMPAD_1 = 97;
  static int NUMPAD_2 = 98;
  static int NUMPAD_3 = 99;
  static int NUMPAD_4 = 100;
  static int NUMPAD_5 = 101;
  static int NUMPAD_6 = 102;
  static int NUMPAD_7 = 103;
  static int NUMPAD_8 = 104;
  static int NUMPAD_9 = 105;
}
