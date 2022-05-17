import 'package:xq_json_csv/args/args.dart';
import 'package:xq_json_csv/command/csv_command.dart';
import 'package:xq_json_csv/command/translate.dart';

void main(List<String> arguments) async {
  final action = CommandAction(arguments);
  switch (action.action) {
    case CommandAction.helpArg:
      printHelp();
      break;
    case CommandAction.translateArg:
      // 取得輸入的檔案
      await TranslateCommand(action.result).execute();
      break;
    case CommandAction.csvArg:
      // 取得輸入的檔案
      await CsvCommand(action.result).execute();
      break;
  }
}
