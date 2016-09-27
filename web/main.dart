// Copyright (c) 2016, Nathan Karasch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:browser_cli/command_line_interface.dart';
import 'package:browser_cli/process_library.dart';

CommandLineInterface interface;

void main() {
  interface = new CommandLineInterface();
  _registerProcesses();
}

_registerProcesses() {
  interface.processManager.registerProcessFactories([
    new EchoProcessFactory(),
    new ExportProcessFactory(),
    new HelpProcessFactory(),
    new JobsProcessFactory(),
    new PrintEnvProcessFactory(),
//    new TestInputProcessFactory(),  // Un-comment this line to see what requesting StdIn for a process looks like!
    new UnsetProcessFactory()
  ]);
}
