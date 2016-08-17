library process.help;

import 'dart:async';
import 'dart:html';

import 'package:hello_morpheus/process_manager.dart';

class HelpProcessFactory extends ProcessFactory {
  static final String COMMAND = 'help';

  HelpProcessFactory() : super(COMMAND);

  HelpProcess createProcess(int id, List args) =>
      new HelpProcess(id, COMMAND, args);
}

class HelpProcess extends Process {
  HelpProcess(int id, String command, List args) : super(id, command, args);

  Future start() async {
    if (args.isEmpty) {
      await _displayHelpHelp();
    } else {
      await _parseArgs();
    }
    exit(0);
  }

  _displayHelpHelp() {
    // TODO
    var div = new DivElement()..setInnerHtml('''
Bacon ipsum dolor amet bacon cow alcatra doner tongue pork. Meatloaf tenderloin kielbasa, cow turducken turkey capicola venison spare ribs. Bresaola kevin cupim, picanha capicola landjaeger ham hock. Strip steak cow jowl landjaeger alcatra beef ham, hamburger ham hock sausage. Pork corned beef pastrami kielbasa swine ham beef, tail doner shankle andouille pig meatball meatloaf fatback.<br>
<br>
Ground round short loin alcatra cupim, meatball filet mignon short ribs turducken shank ham hock landjaeger. Sausage hamburger andouille ham hock boudin pancetta landjaeger salami biltong jowl spare ribs cupim chicken meatball bacon. T-bone alcatra doner sirloin pork loin leberkas ribeye chicken jowl meatloaf pork chop tenderloin jerky beef frankfurter. Andouille ham hock pork belly, boudin pork loin tenderloin tri-tip beef ribs prosciutto bresaola leberkas ham. Pig drumstick shoulder landjaeger pastrami short loin venison sausage.<br>
<br>
Salami ground round chicken, shoulder spare ribs jerky capicola. Short loin venison shoulder t-bone. Chicken swine short ribs boudin, tenderloin fatback prosciutto tongue turducken turkey pork. Pork belly tenderloin chicken bresaola rump ribeye andouille kielbasa pork loin cow biltong turkey prosciutto venison tri-tip. Alcatra shank sirloin prosciutto, meatball shoulder pig kielbasa leberkas boudin cow chuck pork chop. Capicola frankfurter cow filet mignon alcatra hamburger.<br>
<br>
Pork belly ham boudin frankfurter venison beef ribs spare ribs. Filet mignon drumstick beef ribs, tri-tip fatback cow pork chop pancetta prosciutto. Turkey filet mignon short loin frankfurter hamburger leberkas meatball short ribs chuck kevin drumstick chicken. Biltong chuck ground round jerky jowl bacon cow shank. Turducken bresaola biltong, strip steak swine cupim prosciutto meatloaf spare ribs fatback bacon. Tenderloin short ribs cow, porchetta turkey short loin drumstick tongue landjaeger prosciutto ball tip tri-tip turducken frankfurter. Bacon alcatra short ribs t-bone, meatball boudin ribeye hamburger leberkas pancetta short loin shankle cupim ball tip.<br>
<br>
Jowl short loin ham hock leberkas flank, tenderloin swine andouille pork hamburger rump shankle t-bone. Sirloin hamburger filet mignon, short ribs chuck chicken pork porchetta pork loin salami. Kevin ham hock bresaola landjaeger pig ham short loin porchetta flank tongue short ribs salami. Beef ribs turducken landjaeger, rump prosciutto cow shoulder boudin leberkas kielbasa frankfurter shankle.
    ''');
    div.className = 'visible-scroll bordered-scroll-area';
    output(div);
  }

  _parseArgs() {
    // TODO
    output(new DivElement()..text='parsing arguments ${args.toString()}...');
  }
}
