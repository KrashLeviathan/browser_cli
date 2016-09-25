library environment_variables;

/// A singleton that contains global variables available to any process. They just need to import
/// this file to be able to access global environment variables.
class EnvVars {
  static EnvVars _envVarsSingleton;

  /// Returns a copy of the environment variables map.
  Map<String, String> get variablesCopy => new Map.from(_variables);
  Map<String, String> _variables = new Map();

  EnvVars._internal() {
    _envVarsSingleton = this;
  }

  /// Will always return the same singleton [EnvVars] object.
  factory EnvVars() =>
      (_envVarsSingleton == null) ? new EnvVars._internal() : _envVarsSingleton;

  /// Fetches the environment variable with the given [varName].
  String get(String varName) => _variables[varName];

  /// Sets `[varName] = [value]`. [varName] must be less than 79 characters long.
  void set(String varName, String value) {
    if (varName.length > 78) {
      throw new Exception(
          'Environment variable name must be less than 79 characters long!');
    }
    _variables[varName] = value;
  }
}
