import 'package:xq_json_csv/model/csv/csv.dart';

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

  @override
  CsvData parseToCsv(LangEnum langEnum) {
    String zhTW = '';
    String zhCN = '';
    String enEN = '';
    String thTH = '';
    String jpJP = '';
    String krKR = '';
    String vnVN = '';

    switch (langEnum) {
      case LangEnum.en:
        enEN = source;
        break;
      case LangEnum.tw:
        zhTW = source;
        break;
      case LangEnum.cn:
        zhCN = source;
        break;
      case LangEnum.jp:
        jpJP = source;
        break;
      case LangEnum.kr:
        krKR = source;
        break;
      case LangEnum.th:
        thTH = source;
        break;
      case LangEnum.vi:
        vnVN = source;
        break;
    }

    return CsvData(
      zhTW: zhTW,
      zhCN: zhCN,
      enEN: enEN,
      thTH: thTH,
      thThCount: '',
      thThSugCount: '',
      jpJP: jpJP,
      jpJPCount: '',
      jpJPSubCount: '',
      krKR: krKR,
      krKRCount: '',
      krKRSugCount: '',
      vnVN: vnVN,
      vnVNCount: '',
      vnVNSugCount: '',
      jsonKey: [localKey],
    );
  }
}
