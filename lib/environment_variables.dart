library environment_variables;

import 'dart:html' show document;
import 'package:browser_cli/utils.dart';

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

  /// Returns `true` if the input results in an assignment expression.
  static bool variableGetsAssigned(String input, RegExp assignmentExp) {
    if (assignmentExp.hasMatch(input)) {
      var envVars = new EnvVars();
      assignmentExp.allMatches(input).forEach((match) {
        envVars.set(match.group(1), trimAndStripQuotes(match.group(2)),
            persist: true);
      });
      return true;
    } else {
      return false;
    }
  }

  /// Recursive function that returns the part of the string containing the
  /// first match concatenated with _replaceMatchesWithEnvVars(str) until there
  /// are no more matches.
  static String replaceMatchesWithEnvVars(String str, RegExp replacementExp) {
    if (replacementExp.hasMatch(str)) {
      var match = replacementExp.firstMatch(str);
      var replacement = new EnvVars().get(match.group(1)).toString();
      str = str.replaceRange(match.start, match.end, replacement);
      var nextStartingIndex = match.start + replacement.length;
      var leftHalf = str.substring(0, nextStartingIndex);
      if (leftHalf.length == str.length) {
        return leftHalf;
      } else {
        var rightHalf = str.substring(nextStartingIndex);
        return leftHalf + replaceMatchesWithEnvVars(rightHalf, replacementExp);
      }
    } else {
      return str;
    }
  }
}
