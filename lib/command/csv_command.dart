import 'dart:io';

import 'package:args/args.dart';
import 'package:xq_json_csv/csv_parser.dart';
import 'package:xq_json_csv/model/csv/csv.dart';

class CsvCommand {
  final ArgResults argsResult;

  CsvCommand(this.argsResult);

  Future<void> execute() async {
    verifyArgs();

    final inFilePath = argsResult['in'] as String;
    final out = argsResult['out'] as String;
    String outFilePath = out.endsWith("/") ? out.substring(0, out.length - 1) : out;

    final csvParser = CsvValueParser.fromFile(File(inFilePath));

    Map<String, String> names = {
      '$outFilePath/strings_en.i18n.json': csvParser.toJsonString(LangEnum.en),
      '$outFilePath/strings_zh_Hans.i18n.json': csvParser.toJsonString(LangEnum.cn),
      '$outFilePath/strings_zh_Hant.i18n.json': csvParser.toJsonString(LangEnum.tw),
      '$outFilePath/strings_ko.i18n.json': csvParser.toJsonString(LangEnum.kr),
      '$outFilePath/strings_ja.i18n.json': csvParser.toJsonString(LangEnum.jp),
      '$outFilePath/strings_vi.i18n.json': csvParser.toJsonString(LangEnum.vi),
      '$outFilePath/strings_th.i18n.json': csvParser.toJsonString(LangEnum.th),
    };

    names.forEach((key, value) {
      File(key).writeAsStringSync(value);
    });
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
