import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:quiver/iterables.dart';
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

    final enParser = JsonValueParser.fromFile(File('./assets/csv/strings_en.i18n.json'), LangEnum.en);
    final twParser = JsonValueParser.fromFile(File('./assets/csv/strings_zh_Hant.i18n.json'), LangEnum.tw);

    var en = enParser.parseToKeyMap();
    var tw = twParser.parseToKeyMap();
    var ccc = twParser.parseToKeyMap()..remove('zh_TW');

    for (var pair in zip([en.values, tw.values,ccc.values])) {
      print('====================');
      print('dddd $pair');
      // pair[0].join(",")==pair[1].join(",")
    }

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
  }
}
