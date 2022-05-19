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

    final enParser = _jsonValueParser('./assets/csv/strings_en.i18n.json', LangEnum.en);
    final twParser = _jsonValueParser('./assets/csv/strings_zh_Hans.i18n.json', LangEnum.tw);
    final cnParser = _jsonValueParser('./assets/csv/strings_zh_Hant.i18n.json', LangEnum.cn);
    final jpParser = _jsonValueParser('./assets/csv/strings_jp.i18n.json', LangEnum.jp);
    final krParser = _jsonValueParser('./assets/csv/strings_kr.i18n.json', LangEnum.tw);
    final thParser = _jsonValueParser('./assets/csv/strings_th.i18n.json', LangEnum.th);
    final viParser = _jsonValueParser('./assets/csv/strings_vi.i18n.json', LangEnum.vi);

    var en = enParser?.parseToCsvData() ?? [];
    var tw = twParser?.parseToCsvData() ?? [];
    var cn = cnParser?.parseToCsvData() ?? [];
    var jp = jpParser?.parseToCsvData() ?? [];
    var kr = krParser?.parseToCsvData() ?? [];
    var th = thParser?.parseToCsvData() ?? [];
    var vi = viParser?.parseToCsvData() ?? [];

    List<CsvData> csvList = [];
    for (var pair in zip([en, tw, cn, jp, kr, th, vi])) {
      var data = CsvData.fromCsvList(pair[0], pair[1], pair[2], pair[3], pair[4], pair[5], pair[6]);
      csvList.add(data);
    }

    File(outFile).writeAsStringSync(
      ListToCsvConverter().convert(
        [
          titleRow,
          ...csvList.map((e) => e.toCsvString()).toList(),
        ],
      ),
    );
  }

  JsonValueParser? _jsonValueParser(String filePath, LangEnum langEnum) {
    try {
      return JsonValueParser.fromFile(File(filePath), langEnum);
    } catch (e) {
      print('_jsonValueParser exception =========');
      print('$e');
      return null;
    }
  }

  /// 驗證輸入參數
  void verifyArgs() {
    final inFile = argsResult['in'] as String?;
    final outFile = argsResult['out'] as String?;

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
