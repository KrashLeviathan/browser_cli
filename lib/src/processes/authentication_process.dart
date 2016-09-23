library process.authentication;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class AuthenticationProcessFactory extends ProcessFactory {
  static final String COMMAND = 'authenticate';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  AuthenticationProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  AuthenticationProcess createProcess(int id, List args) =>
      new AuthenticationProcess(id, COMMAND, args, this);
}

class AuthenticationProcess extends Process {
  AuthenticationProcess(
      int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    // TODO: Actually need to authenticate
    await output(new DivElement()
      ..text =
          'Last login: ${new DateTime.now()} on ${window.location.hostname}');
    exit(0);
  }
}
