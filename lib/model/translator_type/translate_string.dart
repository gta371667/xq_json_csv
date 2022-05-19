import 'translate_type.dart';

class TranslateString extends TranslateType<String> {
  final String source;

  TranslateString(this.source, String localKey) : super(localKey);

  @override
  String toTranslateSource() {
    return source;
  }

  @override
  void bindTranslateValue(String locale, String value) {
    translate[locale] = value;
  }

  @override
  String exportJson() {
    return source;
  }

  @override
  List<String> allValue() {
    return [source];
  }
}
