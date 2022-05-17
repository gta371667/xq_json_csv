import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:xq_json_csv/csv_parser.dart';
import 'package:xq_json_csv/model/csv/csv.dart';
import 'package:xq_json_csv/parser.dart';

import '../model/csv/test_data.dart';

class TranslateCommand {
  final ArgResults argsResult;

  TranslateCommand(this.argsResult);

  Future<void> execute() async {
    verifyArgs();

    final inFile = argsResult['in'] as String;
    final outFile = argsResult['out'] as String;
    final fromLanguage = argsResult['from'] as String;
    final toLanguage = argsResult['to'] as String;

    final parser = JsonValueParser.fromFile(File(inFile));
    var g = parser.parseToCSV();

    final csvParser = CsvValueParser.fromFile(File('./assets/test_csv.csv'));

    var gg = csvParser.toJsonString(LangEnum.jp);

    var converter = const ListToCsvConverter();
    File(outFile).writeAsStringSync(converter.convert(multipleRows));
  }

  /// 驗證輸入參數
  void verifyArgs() {
    final inFile = argsResult['in'] as String?;
    final outFile = argsResult['out'] as String?;
    final fromLanguage = argsResult['from'] as String?;
    final toLanguage = argsResult['to'] as String?;

    if (inFile == null) {
      throw '缺少必要參數(in/i): 來源檔案';
    } else if (!File(inFile).existsSync()) {
      throw '找不到來源檔案';
    }

    if (outFile == null) {
      throw '缺少必要參數(out/o): 輸出檔案';
    }

    if (fromLanguage == null) {
      throw '缺少必要參數(from/f): 來源語系';
    }

    if (toLanguage == null) {
      throw '缺少必要參數(to/t): 目標語系';
    }
  }
}
