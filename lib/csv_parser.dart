import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

import 'model/csv/csv.dart';

class CsvValueParser {
  /// csv檔案原始字串
  final String _csvString;

  /// 解析後csv欄位列表
  late List<CsvData> csvRow;

  CsvValueParser.fromFile(File csvFile) : _csvString = csvFile.readAsStringSync() {
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(_csvString);
    csvRow = rowsAsListOfValues.map((e) {
      return CsvData.fromRow(e.map((e) => e.toString()).toList());
    }).toList();
  }

  /// TranslateType map轉換為json
  String toJsonString(LangEnum langEnum) {
    var list = csvRow.map((e) => e.toJson(langEnum)).toList();
    Map<String, dynamic> jsonMap = {};

    for (List<Map<String, dynamic>> a in list) {
      for (Map<String, dynamic> map in a) {
        jsonMap.addAll(_mergeMap(jsonMap, map));
      }
    }

    return JsonEncoder.withIndent('  ').convert(jsonMap);
  }

  /// 合併jsonMap
  /// 因為addAll會覆蓋重複key的值，故用輪詢方式加入
  Map<String, dynamic> _mergeMap(Map<String, dynamic> firstMap, Map<String, dynamic> secondMap) {
    var mergedMap = Map<String, dynamic>.from(firstMap);

    for (var entry in secondMap.entries) {
      if (mergedMap[entry.key] == null) {
        mergedMap[entry.key] = entry.value;
      } else if (mergedMap[entry.key] is Map<String, dynamic>) {
        mergedMap[entry.key] = _mergeMap(mergedMap[entry.key], entry.value);
      }
    }
    return mergedMap;
  }
}
