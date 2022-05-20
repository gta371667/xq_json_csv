import 'dart:convert';
import 'dart:io';

import 'package:xq_json_csv/model/csv/csv.dart';

import 'model/translator_type/translate_type.dart';

class JsonValueParser {
  final String _jsonString;

  late TranslateMap _parseData;

  /// 語系
  final LangEnum langEnum;

  JsonValueParser.fromFile(File jsonFile, this.langEnum) : _jsonString = jsonFile.readAsStringSync() {
    final jsonObject = json.decode(_jsonString) as Map<String, dynamic>;
    _parseData = TranslateMap(_parseMap(jsonObject, ''), '');
  }

  List<CsvData> parseToCsvData() {
    var map = _parseToKeyMap();
    List<CsvData> list = [];

    map.forEach((key, value) {
      if (key.isNotEmpty) {
        list.add(CsvData.fromKeyMap(langEnum, key, value));
      }
    });

    return list;
  }

  /// 翻譯文字當key,value為json路經
  /// ex: {"Features":["signUp.futuresChartFullScreen.bottomSheet.header","signUp.header"]}
  Map<String, List<String>> _parseToKeyMap() {
    // 所有翻譯文字
    var allValues = _parseData.allValue();
    Map<String, List<String>> valueMap = {};
    for (var element in allValues) {
      valueMap[element] = [];
    }

    valueMap.forEach((key, value) {
      var list = <String>[];
      _parseData.source.forEach((translateKey, translateMapValue) {
        if (translateMapValue is TranslateString) {
          if (translateMapValue.source == key) {
            list.add(translateMapValue.localKey);
          }
        } else if (translateMapValue is TranslateMap) {
          list.addAll(findValueInTranslateMap(key, translateMapValue));
        }
      });
      value.addAll(list);
    });

    return valueMap;
  }

  /// 尋找translateMap內符合翻譯文字的localKey
  List<String> findValueInTranslateMap(String valueKey, TranslateMap translateMap) {
    List<String> list = [];

    translateMap.source.forEach((key, value) {
      if (value is TranslateString) {
        if (value.source == valueKey) {
          list.add(value.localKey);
        }
      } else if (value is TranslateMap) {
        list.addAll(findValueInTranslateMap(valueKey, value));
      }
    });

    return list;
  }

  /// json轉換為TranslateType map
  Map<String, TranslateType> _parseMap(Map<String, dynamic> jsonObject, String parentKey) {
    return jsonObject.map((key, value) {
      String ky = parentKey.isEmpty ? key : '$parentKey.$key';

      if (value is Map<String, dynamic>) {
        return MapEntry(key, TranslateMap(_parseMap(value, ky), ky));
      } else {
        final valueString = value as String;
        return MapEntry(key, TranslateString(valueString, ky));
      }
    });
  }
}
