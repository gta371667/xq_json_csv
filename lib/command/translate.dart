import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:quiver/iterables.dart';
import 'package:xq_json_csv/model/csv/csv.dart';
import 'package:xq_json_csv/parser.dart';

class TranslateCommand {
  final ArgResults argsResult;

  TranslateCommand(this.argsResult);

  Future<void> execute() async {
    verifyArgs();

    final inFile = argsResult['in'] as String;
    final outFile = argsResult['out'] as String;

    if (File(inFile).existsSync()) {
      print('指定檔案模式，將產生csv');

      final fromLang = argsResult['lang'] as String?;
      if (fromLang == null) {
        print('無-f指定語系，將使用預設zh-tw');
      } else {
        print('指定語系:$fromLang');
      }
      final lang = toLangEnum(fromLang ?? 'zh-tw');

      final parser = _jsonValueParser(inFile, lang);
      var list = parser?.parseToCsvData() ?? [];

      File(outFile).writeAsStringSync(
        ListToCsvConverter().convert(
          [
            titleRow,
            ...list.map((e) => e.toCsvString()).toList(),
          ],
        ),
      );
    } else {
      print('使用檔案路徑，將產生csv');

      final enParser = _jsonValueParser('$inFile/strings_en.i18n.json', LangEnum.en);
      final twParser = _jsonValueParser('$inFile/strings_zh_Hans.i18n.json', LangEnum.tw);
      final cnParser = _jsonValueParser('$inFile/strings_zh_Hant.i18n.json', LangEnum.cn);
      final jpParser = _jsonValueParser('$inFile/strings_jp.i18n.json', LangEnum.jp);
      final krParser = _jsonValueParser('$inFile/strings_kr.i18n.json', LangEnum.tw);
      final thParser = _jsonValueParser('$inFile/strings_th.i18n.json', LangEnum.th);
      final viParser = _jsonValueParser('$inFile/strings_vi.i18n.json', LangEnum.vi);

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

  /// 語系對應
  LangEnum toLangEnum(String text) {
    switch (text) {
      case 'en':
        return LangEnum.en;
      case 'zh-tw':
        return LangEnum.tw;
      case 'zh-cn':
        return LangEnum.cn;
      case 'jp':
        return LangEnum.jp;
      case 'kr':
        return LangEnum.kr;
      case 'vi':
        return LangEnum.vi;
      case 'th':
        return LangEnum.th;
      default:
        print('\n無符合語系，將使用預設cn');
        print('語系對應表:');
        print('en、zh-tw、zh-cn、jp、kr、vi、th');
        return LangEnum.cn;
    }
  }

  /// 驗證輸入參數
  void verifyArgs() {
    final inFile = argsResult['in'] as String?;
    final outFile = argsResult['out'] as String?;

    if (inFile == null) {
      throw '缺少必要參數(in/i): 來源檔案';
    }

    if (outFile == null) {
      throw '缺少必要參數(out/o): 輸出檔案';
    }
  }
}
