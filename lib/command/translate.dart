import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:xq_json_csv/model/csv/csv.dart';
import 'package:xq_json_csv/parser.dart';

class TranslateCommand {
  final ArgResults argsResult;

  TranslateCommand(this.argsResult);

  Future<void> execute() async {
    verifyArgs();

    final inFile = argsResult['in'] as String;
    final outFile = argsResult['out'] as String;

    // final tw = '已切換為{state}g{qqq}ll';
    // final text = tw
    //     .trim()
    //     .replaceAll(' ', '')
    //     .replaceAll(',', '')
    //     .replaceAll('.', '')
    //     .replaceAllMapped(RegExp(r'\{\D{1,999}\}'), (v) {
    //
    //   return 'ccccc';
    // });
    //
    // var a = text;
    // print('指定檔案模式，將產生csvAAA $a');
    //
    // return;

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
      print('使用檔案路徑，將產生csv，以tw為主');

      // final enParser = _jsonValueParser('$inFile/strings_en.i18n.json', LangEnum.en);
      // final twParser = _jsonValueParser('$inFile/strings.i18n.json', LangEnum.tw);
      // final cnParser = _jsonValueParser('$inFile/strings_zh_Hans.i18n.json', LangEnum.cn);
      // final jpParser = _jsonValueParser('$inFile/strings_ja.i18n.json', LangEnum.jp);
      // final krParser = _jsonValueParser('$inFile/strings_ko.i18n.json', LangEnum.kr);
      // final thParser = _jsonValueParser('$inFile/strings_th.i18n.json', LangEnum.th);
      // final viParser = _jsonValueParser('$inFile/strings_vi.i18n.json', LangEnum.vi);

      final enParser = _jsonValueParser('$inFile/en.json', LangEnum.en);
      final twParser = _jsonValueParser('$inFile/zh_Hant.json', LangEnum.tw);
      final cnParser = _jsonValueParser('$inFile/zh_Hans.json', LangEnum.cn);
      final jpParser = _jsonValueParser('$inFile/ja.json', LangEnum.jp);
      final krParser = _jsonValueParser('$inFile/ko.json', LangEnum.kr);
      final thParser = _jsonValueParser('$inFile/th.json', LangEnum.th);
      final viParser = _jsonValueParser('$inFile/vi.json', LangEnum.vi);

      var en = enParser?.parseToCsvData() ?? [];
      var tw = twParser?.parseToCsvData() ?? [];
      var cn = cnParser?.parseToCsvData() ?? [];
      var jp = jpParser?.parseToCsvData() ?? [];
      var kr = krParser?.parseToCsvData() ?? [];
      var th = thParser?.parseToCsvData() ?? [];
      var vi = viParser?.parseToCsvData() ?? [];

      var a = tw.indexWhere((element) => element.zhTW == '手機號格式錯誤');
      var b = en.indexWhere((element) => element.enEN == 'Value');

      List<CsvData> csvList = tw.map((e) {
        var enCsv = findWhere(en, e);
        var cnCsv = findWhere(cn, e);
        var jpCsv = findWhere(jp, e);
        var krCsv = findWhere(kr, e);
        var thCsv = findWhere(th, e);
        var viCsv = findWhere(vi, e);
        return CsvData.fromCsvList(cn: cnCsv, en: enCsv, jp: jpCsv, kr: krCsv, th: thCsv, tw: e, vi: viCsv);
      }).toList();

      // for (var pair in zip([en, tw, cn, jp, kr, th, vi])) {
      //   var data = CsvData.fromCsvList(pair[0], pair[1], pair[2], pair[3], pair[4], pair[5], pair[6]);
      //   csvList.add(data);
      // }

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

  CsvData? findWhere(List<CsvData> list, CsvData data) {
    int idx = list.indexWhere((element) {
      // TODO 發現en有value重複，造成en key會有多把
      var firstList = element.jsonKey.toSet();
      var secondList = data.jsonKey.toSet();
      return firstList.intersection(secondList).isNotEmpty;
    });
    if (idx != -1) {
      return list[idx];
    }
    return null;
  }
}
