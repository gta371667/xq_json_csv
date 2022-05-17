import 'dart:convert';
import 'dart:io';

import 'model/translator_type/translate_type.dart';

class JsonValueParser {
  final String _jsonString;

  late TranslateMap _parseData;

  JsonValueParser.fromFile(File jsonFile) : _jsonString = jsonFile.readAsStringSync() {
    final jsonObject = json.decode(_jsonString) as Map<String, dynamic>;
    _parseData = TranslateMap(_parseMap(jsonObject, ''), '');
  }

  void parse() {
    _parseData.allValue();
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

  /// TranslateType map轉換為json
  String toJsonString() {
    return json.encode(_parseData);
  }
}
