# Getting Started

## Add code to html page

The following goes inside the `<head>`:

```html
<script defer src="main.dart" type="application/dart"></script>
<script defer src="packages/browser/dart.js"></script>
```

In the `<body>`, where you want the shell located, add the following:

```html
<div id="browser-cli-shell"></div>
```


## Create or import processes

Any process that you want to run in the CLI needs to extend the
`Process` class, and it needs to also have a factory that extends
the `ProcessFactory` class.

### ProcessFactory Example:

```dart
class FoobarProcessFactory extends ProcessFactory {
  static final String COMMAND = 'foobar';

  FoobarProcessFactory() : super(COMMAND);

  FoobarProcess createProcess(int id, List args) =>
      new FoobarProcess(id, COMMAND, args);
}
```

### Process Example:

```dart
class FoobarProcess extends Process {
  FoobarProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    // Implement the process here...
    
    exit(0);
  }
}
```


## Create a main.dart and register desired process factories

```dart
import 'package:browser_cli/command_line_interface.dart';
import 'package:browser_cli/process_library.dart';
import 'package:my_cool_project/process_library.dart';

CommandLineInterface interface;

void main() {
  interface = new CommandLineInterface();
  _registerProcesses();
}

_registerProcesses() {
  interface.processManager.registerProcessFactories([
    new CdProcessFactory(),
    new JobsProcessFactory(),
    new HelpProcessFactory(),
    new FoobarProcessFactory()
    // ...
  ]);
}
```


## Style your CLI

Here are some of the id and class names used by browser_cli:

### id

- `browser_cli_shell` - The container for the CLI shell.
- `cli-standard-input` - The div the user types in.
- `cli-prompt` - The leading bit of text in the standard input
  div. Defaults to "~ user$"
- `cli-last-output` - The last div output to the shell.

### class

- `cli-output` - This class applies to all output divs.
- `cli-stderr` - This class is added to an output div when it's
  displaying an error message.
- `cli-input` - This class applies to all (current and previous)
  input divs.
- `cli-visible-scroll` - When you want a scrollbar in an output div.
- `cli-bordered-scroll-area` - When you want the scroll area to
  have a border.
- `cli-hidden` - When you want something to be hidden.
