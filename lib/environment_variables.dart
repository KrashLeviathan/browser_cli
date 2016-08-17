library environment_variables;

/// A singleton that contains global variables available to any process. They just need to import
/// this file to be able to access global environment variables.
class EnvVars {
  static EnvVars _envVarsSingleton;
  Map<String, String> _variables = new Map();

  EnvVars._internal() {
    _envVarsSingleton = this;
  }

  /// Will always return the same singleton [EnvVars] object.
  factory EnvVars() => (_envVarsSingleton == null) ? new EnvVars._internal() : _envVarsSingleton;

  /// Fetches the environment variable with the given [varName].
  String get(String varName) => _variables[varName];

  /// Sets `[varName] = [value]`. [varName] must be less than 79 characters long.
  void set(String varName, String value) {
    if (varName.length > 78) {
      throw new Exception('Environment variable name must be less than 79 characters long!');
    }
    _variables[varName] = value;
  }

  /// Returns a list of all the environment variables in the format:
  ///
  ///     HOME                     = 'My Snazzy Home Folder'
  ///     FOOBAR                   = 'Some variable'
  ///     A_LONG_ENV_VARIABLE_NAME = 'Something important, I'm sure'
  List<String> get printEnv {
    var list = new List();
    var longestLength = 0;
    _variables.keys.forEach((key) {
      if (key.length > longestLength) {
        longestLength = key.length;
      }
    });
    _variables.keys.forEach((key) {
      list.add('${key.padRight(longestLength)} = \'${_variables[key]}\'');
    });
    return list;
  }
}
