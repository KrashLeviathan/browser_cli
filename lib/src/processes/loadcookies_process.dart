library process.loadcookies;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/environment_variables.dart';
import 'package:browser_cli/process_manager.dart';

class LoadCookiesProcessFactory extends ProcessFactory {
  static final String COMMAND = 'loadcookies';
  static final String USAGE = 'USAGE: loadcookies';
  static final String SHORT_DESCRIPTION = 'Loads information from the document '
      'cookies.';
  static final String LONG_DESCRIPTION = 'Loads information from the document '
      'cookies.';

  LoadCookiesProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  LoadCookiesProcess createProcess(int id, List args) =>
      new LoadCookiesProcess(id, COMMAND, args, this);
}

/// Loads information from the document cookies.
class LoadCookiesProcess extends Process {
  LoadCookiesProcess(
      int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      output(new DivElement()..text = factory.usage);
      exit(1);
    } else {
      await _loadCookieInformation();
    }
  }

  void _loadCookieInformation() {
    var envVars = new EnvVars()..loadFromCookies();
    var last_login_time = envVars.get('last_login_time');
    var last_login_location = envVars.get('last_login_location');
    if (last_login_time != null && last_login_time.isNotEmpty) {
      output(new DivElement()
        ..text = 'Last login: $last_login_time on $last_login_location');
    } else {
      output(new DivElement()
        ..text = 'No previous login information found in document cookies! '
            'This means it\'s either your first login, or the document cookies '
            'were cleared.');
      _addDefaultVars();
    }
    envVars.set('last_login_time', new DateTime.now().toString(),
        persist: true);
    envVars.set('last_login_location', window.location.hostname, persist: true);
  }

  void _addDefaultVars() {
    new EnvVars()
      ..set(
          'PATH',
          '"Do not go where the path may lead, go instead where '
          'there is no path and leave a trail." - Ralph Waldo Emerson',
          persist: true)
      ..set(
          'HOME',
          '"Home is the place where, when you have to go there, '
          'they have to take you in." - Robert Frost',
          persist: true);
  }
}
