library environment_variables;

import 'dart:html' show document;

/// A singleton that contains global variables available to any process. They just need to import
/// this file to be able to access global environment variables.
class EnvVars {
  static EnvVars _envVarsSingleton;

  /// Returns a copy of the environment variables map.
  Map<String, String> get variablesCopy =>
      new Map()..addAll(_persistingVariables)..addAll(_tempVariables);
  Map<String, String> _persistingVariables = new Map();
  Map<String, String> _tempVariables = new Map();

  /// The prefix to all cookie names
  static const cookiePrefix = "browser_cli_";

  EnvVars._internal() {
    _envVarsSingleton = this;
  }

  /// Will always return the same singleton [EnvVars] object.
  factory EnvVars() =>
      (_envVarsSingleton == null) ? new EnvVars._internal() : _envVarsSingleton;

  /// Fetches the environment variable with the given [varName].
  String get(String varName) => _persistingVariables[varName];

  /// Sets `[varName] = [value]`. [varName] must be less than 79 characters long.
  void set(String varName, String value, {bool persist: false}) {
    if (varName.length > 78) {
      throw new Exception(
          'Environment variable name must be less than 79 characters long!');
    }
    if (persist) {
      _persistingVariables[varName] = value;
      document.cookie = "$cookiePrefix$varName=$value";
    } else {
      _tempVariables[varName] = value;
    }
  }

  /// Loads variables that were previously stored in the document cookies.
  void loadFromCookies() {
    var cookies = document.cookie.split('; ');
    cookies.forEach((cookie) {
      if (cookie.startsWith(cookiePrefix)) {
        var kvPair = cookie.substring(cookiePrefix.length).split('=');
        _persistingVariables[kvPair[0]] = kvPair[1];
      }
    });
  }
}
