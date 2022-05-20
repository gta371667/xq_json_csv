import 'translate_type.dart';

class TranslateMap extends TranslateType<Map<String, dynamic>> {
  final Map<String, TranslateType> source;

  static const splitPattern = '\n===\n';

  TranslateMap(this.source, String localKey) : super(localKey);

  @override
  String toTranslateSource() {
    return source.entries.map((e) => e.value.toTranslateSource()).join(splitPattern);
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
