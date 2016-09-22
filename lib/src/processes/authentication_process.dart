library process.authentication;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class AuthenticationProcessFactory extends ProcessFactory {
  static final String COMMAND = 'authenticate';

  AuthenticationProcessFactory() : super(COMMAND);

  AuthenticationProcess createProcess(int id, List args) =>
      new AuthenticationProcess(id, COMMAND, args);
}

class AuthenticationProcess extends Process {
  AuthenticationProcess(int id, String command, List args)
      : super(id, command, args);

  Future start() async {
    // TODO: Actually need to authenticate
    await output(new DivElement()
      ..text =
          'Last login: ${new DateTime.now()} on ${window.location.hostname}');
    exit(0);
  }

  Future kill([String message]) async {
    // TODO: Actually need to do something
    /*
    [1] 48817
    [nathankarasch@mac browser_cli]$ kill -9 48817
    [nathankarasch@mac browser_cli]$
    [1]+  Killed: 9               emacs
     */
    await output(new DivElement()..text = 'Killed: $id $command');
  }
}
