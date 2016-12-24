/**
 * This library provides all the concrete [Process] and [ProcessFactory]
 * classes that come standard with browser_cli. It also provides a good
 * resource to look at when designing your own custom [Process].
 *
 * ## NOTE:
 *
 * The testinput process (commented out below) is purely for demonstration
 * purposes for anyone who needs to create a process that requests and uses
 * input from the user.
 */
library process;

// TODO: Processes that are commented out will be part of v2.0.0 or later

export 'package:browser_cli/src/processes/alias_process.dart';
//export 'package:browser_cli/src/processes/cd_process.dart';
export 'package:browser_cli/src/processes/clear_process.dart';
export 'package:browser_cli/src/processes/echo_process.dart';
export 'package:browser_cli/src/processes/export_process.dart';
export 'package:browser_cli/src/processes/help_process.dart';
export 'package:browser_cli/src/processes/jobs_process.dart';
export 'package:browser_cli/src/processes/loadcookies_process.dart';
//export 'package:browser_cli/src/processes/ls_process.dart';
//export 'package:browser_cli/src/processes/man_process.dart';
//export 'package:browser_cli/src/processes/mkdir_process.dart';
export 'package:browser_cli/src/processes/printenv_process.dart';
//export 'package:browser_cli/src/processes/rm_process.dart';
export 'package:browser_cli/src/processes/testinput_process.dart';
export 'package:browser_cli/src/processes/unset_process.dart';
