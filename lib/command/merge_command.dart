import 'dart:io';

import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'package:xq_json_csv/csv_parser.dart';
import 'package:xq_json_csv/model/csv/csv.dart';

class MergeCommand {
  final ArgResults argsResult;

  MergeCommand(this.argsResult);

  Future<void> execute() async {
    verifyArgs();

    final base = argsResult['base'] as String;
    final from = argsResult['from'] as String;
    final out = argsResult['out'] as String;

    final baseParser = CsvValueParser.fromFile(File(base));
    final fromParser = CsvValueParser.fromFile(File(from));

    var mergeList = fromParser.csvRow.map((e) {
      int idx = baseParser.csvRow.indexWhere((element) => element.containsTwKey == e.containsTwKey);
      if (idx != -1) {
        return CsvData.mergeCsv(baseParser.csvRow[idx], e);
      }
      return e;
    }).toList();

    File(out).writeAsStringSync(
      ListToCsvConverter().convert(
        [
          titleRow,
          ...mergeList.map((e) => e.toCsvString()).toList(),
        ],
      ),
    );
  }

  /// 驗證輸入參數
  void verifyArgs() {
    final base = argsResult['base'] as String?;
    final from = argsResult['from'] as String?;
    final out = argsResult['out'] as String?;

    if (base == null) {
      throw '缺少必要參數(base/b): 原始檔案';
    } else if (!File(base).existsSync()) {
      throw '找不到來源檔案';
    }

    if (from == null) {
      throw '缺少必要參數(from/f): 合併檔案';
    } else if (!File(from).existsSync()) {
      throw '找不到合併檔案';
    }

    if (out == null) {
      throw '缺少必要參數(out/o): 輸出檔案';
    }
  }
}
