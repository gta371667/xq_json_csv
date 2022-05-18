import 'translate_type.dart';

class TranslateMap extends TranslateType<Map<String, dynamic>> {
  final Map<String, TranslateType> source;

  static const splitPattern = '\n===\n';

  TranslateMap(this.source, String localKey) : super(localKey);

  @override
  String toTranslateSource() {
    return source.entries.map((e) => e.value.toTranslateSource()).join(splitPattern);
  }

  @override
  void bindTranslateValue(String locale, String value) {
    final valueList = value.split(splitPattern);

    for (var i = 0; i < source.entries.length; i++) {
      final entry = source.entries.toList()[i];
      if (entry.value is TranslateMap) {
        final valueData = valueList.sublist(i).join(splitPattern);
        entry.value.bindTranslateValue(locale, valueData);
      } else {
        final valueData = valueList[i];
        entry.value.bindTranslateValue(locale, valueData);
      }
    }
  }

  /// 輸出翻譯後的json
  @override
  Map<String, dynamic> exportJson() {
    return source.map((key, value) {
      if (value is TranslateMap) {
        final valueJson = value.exportJson();
        return MapEntry(key, valueJson);
      } else if (value is TranslateString) {
        final valueJson = value.exportJson();
        return MapEntry(key, valueJson);
      } else {
        throw '錯誤: 未知型態: $value';
      }
    });
  }

  @override
  List<String> allValue() {
    final List<String> list = [];
    source.forEach((key, value) {
      if (value is TranslateMap) {
        list.addAll(value.toTranslateSource().split(splitPattern));
      } else {
        list.add(value.toTranslateSource());
      }
    });
    return list.toSet().toList();
  }
}
