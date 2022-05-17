export 'translate_map.dart';
export 'translate_string.dart';

abstract class TranslateType<T> {
  final String localKey;

  final translate = <String, String>{};

  TranslateType(this.localKey);

  /// 輸出要進行翻譯的字串值
  String toTranslateSource();

  /// 綁定翻譯後的字串值
  void bindTranslateValue(String locale, String value);

  /// 轉換為json
  T exportJson();

  /// 取得所有值，並過濾重複字串
  List<String> allValue();
}
