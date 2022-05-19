import 'package:args/args.dart';
import 'package:collection/collection.dart';

import 'group.dart';

export 'group.dart';
export 'help_print.dart';

class CommandAction {
  final ArgGroup action;
  final ArgResults result;

  const CommandAction._({required this.action, required this.result});

  factory CommandAction(List<String> args) {
    final code = args.isNotEmpty ? args[0] : null;
    final action = values.firstWhereOrNull((e) => code == e.name) ?? helpArg;
    final result = action.toParser().parse(args);
    return CommandAction._(action: action, result: result);
  }

  static List<ArgGroup> values = [
    helpArg,
    translateArg,
    csvArg,
  ];

  static const helpArg = ArgGroup(
    title: '打印幫助',
    name: 'help',
  );

  static const translateArg = ArgGroup(
    title: '翻譯',
    name: 'translate',
    args: [
      ActionArg.option(name: 'in', abbr: 'i', help: '輸入檔案or路徑'),
      ActionArg.option(name: 'out', abbr: 'o', help: '輸出檔案'),
      ActionArg.option(name: 'lang', abbr: 'f', help: '指定語系'),
    ],
    example: '''
    使用檔案路徑：translate -i ./assets/i18n/ -o ./assets/out.csv
    指定翻譯檔案：translate -i ./assets/i18n/test.json -o ./assets/out.csv -f cn
    ''',
  );

  static const csvArg = ArgGroup(
    title: 'csv轉換多國',
    name: 'csv',
    args: [
      ActionArg.option(name: 'in', abbr: 'i', help: '輸入檔案'),
      ActionArg.option(name: 'out', abbr: 'o', help: '輸出路徑'),
    ],
    example: '''
    csv -i ./assets/out.csv -o ./assets/i18n/
    ''',
  );

  ArgResults parseArg(List<String> args) {
    return action.toParser().parse(args);
  }

  @override
  String toString() {
    return action.toString();
  }
}
