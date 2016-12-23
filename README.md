# browser_cli

This dart package is a Command Line Interface for the web browser. 
Pull it into your website and create some custom processes to have
all the sweet command line goodness at your fingertips!

## Take it for a test ride!

[Click Here](https://krashleviathan.github.io/browser_cli/) to try
it out! Keep in mind you would write custom processes for your own
website when you use it. The only things demonstrated here are the
basics.

## Getting Started

### Add code to html page

The following goes inside the `<head>`:

```html
<script defer src="main.dart" type="application/dart"></script>
<script defer src="packages/browser/dart.js"></script>
```

In the `<body>`, where you want the shell located, add the following:

```html
<div id="cli-shell"></div>
```


### Create or import processes

Any process that you want to run in the CLI needs to extend the
`Process` class, and it needs to also have a factory that extends
the `ProcessFactory` class.

#### ProcessFactory Example:

A ProcessFactory should follow the model below, providing a COMMAND,
USAGE, SHORT_DESCRIPTION, and LONG_DESCRIPTION.

```dart
class EchoProcessFactory extends ProcessFactory {
  static final String COMMAND = 'echo';
  static final String USAGE = 'USAGE: echo <string>';
  static final String SHORT_DESCRIPTION =
      'Prints the supplied input back to the shell.';
  static final String LONG_DESCRIPTION =
      'Prints the supplied input back to the shell';

  EchoProcessFactory()
      : super(COMMAND, USAGE, SHORT_DESCRIPTION, LONG_DESCRIPTION);

  EchoProcess createProcess(int id, List args) =>
      new EchoProcess(id, COMMAND, args, this);
}
```

#### Process Example:

The only two required API for a Process are the constructor and the
`start()` method. Below is a very basic Process, but they can be much
more complex. Check out other Processes in the standard library for
examples of different ways to parse the arguments, how to request
user input within a running process, how to start other processes
from within a process, and more!

```dart
class EchoProcess extends Process {
  EchoProcess(int id, String command, List args, ProcessFactory factory)
      : super(id, command, args, factory);

  Future start() async {
    if (args.isNotEmpty) {
      await output(new DivElement()..text = args.join(' '));
    } else {
      await output(new DivElement()..innerHtml = nonBreakingLineSpace);
    }
  }
}
```


### Create a main.dart and register desired process factories

Make sure to register all the standard library process factories,
as well as any custom process factories you may have.

```dart
import 'package:browser_cli/command_line_interface.dart';
import 'package:browser_cli/process_library.dart';
import 'package:my_cool_project/process_library.dart';

CommandLineInterface interface;

void main() {
  interface = new CommandLineInterface();
  _registerProcesses();
  interface.processManager.startProcess(LoadCookiesProcessFactory.COMMAND);
}

_registerProcesses() {
  interface.processManager.registerProcessFactories([
    new LoadCookiesProcessFactory(),
    new EchoProcessFactory(),
    new ExportProcessFactory(),
    new HelpProcessFactory(),
    new JobsProcessFactory(),
    new PrintEnvProcessFactory(),
    new UnsetProcessFactory(),
    // ...
  ]);
}
```


### Style your CLI

You can use the default stylings provided with the package, or
you can make your own! Below are some (but not all) of the id and
class names used by browser_cli. To get a more complete list,
check out the `utils` library.

#### id

- `cli-shell` - The container for the CLI shell.
- `cli-standard-input` - The div the user types in.
- `cli-prompt` - The leading bit of text in the standard input
  div. Defaults to "~ user$"
- `cli-last-output` - The last div output to the shell.

#### class

- `cli-output` - This class applies to all output divs.
- `cli-stderr` - This class is added to an output div when it's
  displaying an error message.
- `cli-input` - This class applies to all (current and previous)
  input divs.
- `cli-visible-scroll` - When you want a scrollbar in an output div.
- `cli-bordered-scroll-area` - When you want the scroll area to
  have a border.
- `cli-hidden` - When you want something to be hidden.
