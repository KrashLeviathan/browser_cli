library process.jobs;

import 'dart:async';
import 'dart:html';

import 'package:browser_cli/process_manager.dart';

class JobsProcessFactory extends ProcessFactory {
  static final String COMMAND = 'jobs';
  static final String USAGE = '';
  static final String SHORT_DESCRIPTION = '';
  static final String LONG_DESCRIPTION = '';

  JobsProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  JobsProcess createProcess(int id, List args) =>
      new JobsProcess(id, COMMAND, args, this);
}

class JobsProcess extends Process {
  JobsProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (!args.isEmpty) {
      await _parseArgs();
    } else {
      await _displayJobs();
    }
    exit(0);
  }

  _displayJobs({verbose: false}) {
    var pm = new ProcessManager();

    var div = new DivElement();
    var text = new ParagraphElement()..text = "Processes currently running:";
    div.append(text);

    var list = new UListElement();
    pm.processes.keys.forEach((key) {
      var innerHtml = (verbose)
          ? pm.processes[key].toStringVerbose()
          : pm.processes[key].toString();
      var listItem = new LIElement()..innerHtml = innerHtml;
      list.append(listItem);
    });
    div.append(list);

    output(div);
  }

  _parseArgs() {
    if (args.firstWhere((arg) => arg == "-v" || arg == "--verbose",
            orElse: () => null) !=
        null) {
      _displayJobs(verbose: true);
    } else {
      output(new DivElement()..text = usage());
    }
  }

  String usage() {
    return "USAGE: jobs [-v | --verbose]";
  }
}
