/// 語系區分
enum LangEnum {
  en,
  tw,
  cn,
  jp,
  kr,
  th,
  vi,
}

const List<dynamic> titleRow = [
  'zh_TW',
  'zh-CN',
  'en-EN',
  '英文字數',
  '建議字數',
  'th-TH',
  '泰文字數',
  '建議字數',
  'jp-JP',
  '日文字數',
  '建議字數',
  'kr-KR',
  '韓文字數',
  '建議字數',
  'vn-VN',
  '越文字數',
  '建議字數',
  'jsonKey'
];

class CsvData {
  /// csv標準格式，逗號分隔值
  static const String csvStandard = ',';

  /// 繁中
  final String zhTW;

  /// 簡中
  final String zhCN;

  /// 英文
  final String enEN;

  /// 英文字數
  final String enEnCount;

  /// 英文建議數字
  final String enEnSugCount;

  /// 泰文
  final String thTH;

  /// 泰文字數
  final String thThCount;

  /// 泰文建議數字
  final String thThSugCount;

  /// 日文
  final String jpJP;

  /// 日文字數
  final String jpJPCount;

  /// 日文建議數字
  final String jpJPSubCount;

  /// 韓文
  final String krKR;

  /// 韓文文字數
  final String krKRCount;

  /// 韓文建議字數
  final String krKRSugCount;

  /// 越南文
  final String vnVN;

  /// 越南文字數
  final String vnVNCount;

  /// 越南文建議字數
  final String vnVNSugCount;

  /// 對應Key
  final List<String> jsonKey;

  const CsvData({
    required this.zhTW,
    required this.zhCN,
    required this.enEN,
    required this.thTH,
    required this.thThCount,
    required this.thThSugCount,
    required this.jpJP,
    required this.jpJPCount,
    required this.jpJPSubCount,
    required this.krKR,
    required this.krKRCount,
    required this.krKRSugCount,
    required this.vnVN,
    required this.vnVNCount,
    required this.vnVNSugCount,
    required this.jsonKey,
    required this.enEnCount,
    required this.enEnSugCount,
  });

  factory CsvData.fromRow(List<String> row) {
    return CsvData(
      zhTW: row[0],
      zhCN: row[1],
      enEN: row[2],
      enEnCount: row[3],
      enEnSugCount: row[4],
      thTH: row[5],
      thThCount: row[6],
      thThSugCount: row[7],
      jpJP: row[8],
      jpJPCount: row[9],
      jpJPSubCount: row[10],
      krKR: row[11],
      krKRCount: row[12],
      krKRSugCount: row[13],
      vnVN: row[14],
      vnVNCount: row[15],
      vnVNSugCount: row[16],
      jsonKey: row[17].split(csvStandard),
    );
  }

  factory CsvData.fromKeyMap(LangEnum langEnum, String value, List<String> key) {
    String zhTW = '';
    String zhCN = '';
    String enEN = '';
    String thTH = '';
    String jpJP = '';
    String krKR = '';
    String vnVN = '';

    switch (langEnum) {
      case LangEnum.en:
        enEN = value;
        break;
      case LangEnum.tw:
        zhTW = value;
        break;
      case LangEnum.cn:
        zhCN = value;
        break;
      case LangEnum.jp:
        jpJP = value;
        break;
      case LangEnum.kr:
        krKR = value;
        break;
      case LangEnum.th:
        thTH = value;
        break;
      case LangEnum.vi:
        vnVN = value;
        break;
    }

    return CsvData(
      zhTW: zhTW,
      zhCN: zhCN,
      enEN: enEN,
      enEnCount: '',
      enEnSugCount: '',
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
      jsonKey: key,
    );
  }

  factory CsvData.fromCsvList({
    CsvData? en,
    required CsvData tw,
    CsvData? cn,
    CsvData? jp,
    CsvData? kr,
    CsvData? th,
    CsvData? vi,
  }) {
    return CsvData(
      zhTW: tw.zhTW,
      zhCN: cn?.zhCN ?? '',
      enEN: en?.enEN ?? '',
      enEnCount: '',
      enEnSugCount: getSuggestCount(tw.zhTW, LangEnum.en),
      thTH: th?.thTH ?? '',
      thThCount: '',
      thThSugCount: getSuggestCount(tw.zhTW, LangEnum.th),
      jpJP: jp?.jpJP ?? '',
      jpJPCount: '',
      jpJPSubCount: getSuggestCount(tw.zhTW, LangEnum.jp),
      krKR: kr?.krKR ?? '',
      krKRCount: '',
      krKRSugCount: getSuggestCount(tw.zhTW, LangEnum.kr),
      vnVN: vi?.vnVN ?? '',
      vnVNCount: '',
      vnVNSugCount: getSuggestCount(tw.zhTW, LangEnum.vi),
      jsonKey: tw.jsonKey,
    );
  }

  /// 取得建議字數
  static String getSuggestCount(String tw, LangEnum langEnum) {
    final regExp = RegExp(r'\{\D{1,999}\}');

    final text = tw
        .trim()
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .replaceAll('.', '')
        .replaceAll('\n', '')
        .replaceAllMapped(regExp, (v) => '');

    int count() {
      switch (langEnum) {
        case LangEnum.en:
          return (text.length * 2.2).toInt();
        case LangEnum.tw:
          return text.length;
        case LangEnum.cn:
          return text.length;
        case LangEnum.jp:
          return text.length;
        case LangEnum.kr:
          return (text.length * 1.4).toInt();
        case LangEnum.th:
          return (text.length * 1.1818).toInt();
        case LangEnum.vi:
          return (text.length * 2.25).toInt();
      }
    }

    if (regExp.hasMatch(tw)) {
      return '${count()} + ?';
    } else {
      return '${count()}';
    }
  }

  /// 轉換為csv保存格式
  List<String> toCsvString() {
    return [
      zhTW,
      zhCN,
      enEN,
      enEnCount,
      enEnSugCount,
      thTH,
      thThCount,
      thThSugCount,
      jpJP,
      jpJPCount,
      jpJPSubCount,
      krKR,
      krKRCount,
      krKRSugCount,
      vnVN,
      vnVNCount,
      vnVNSugCount,
      jsonKey.join(csvStandard),
    ];
  }

  /// 轉換為json文字
  List<Map<String, dynamic>> toJson(LangEnum langEnum) {
    return jsonKey.map((e) {
      var sp = e.split(".");
      return _parentList(sp, _getValue(langEnum));
    }).toList();
  }

  /// 取得翻譯文字
  String _getValue(LangEnum langEnum) {
    switch (langEnum) {
      case LangEnum.en:
        return enEN;
      case LangEnum.tw:
        return zhTW;
      case LangEnum.cn:
        return zhCN;
      case LangEnum.jp:
        return jpJP;
      case LangEnum.kr:
        return krKR;
      case LangEnum.th:
        return thTH;
      case LangEnum.vi:
        return vnVN;
    }
  }

  Map<String, dynamic> _parentList(List<String> spKeys, String value) {
    Map<String, dynamic> map = {};

    if (spKeys.length == 1 && spKeys.first.isEmpty) {
      return {};
    }

    if (spKeys.length == 1) {
      return {spKeys.first: value};
    }

    String parentKey = spKeys.first;
    map[spKeys.first] = _childList({}, spKeys.sublist(1).join("."), value, parentKey);
    return map;
  }

  dynamic _childList(Map<String, dynamic> map, String key, value, String parentKey) {
    if (key.isEmpty) return value;
    var sp = key.split(".");

    for (var i = 0; i < sp.length; i++) {
      if (map.isEmpty) {
        map.addAll({
          sp[i]: _childList({}, sp.sublist(i + 1).join("."), value, sp[i]),
        });
      }
    }
    return map;
  }

  factory CsvData.mergeCsv(CsvData base, CsvData from) {
    return CsvData(
      zhTW: base.zhTW,
      zhCN: base.zhCN,
      enEN: base.enEN,
      enEnSugCount: base.enEnSugCount,
      enEnCount: base.enEnCount,
      thTH: base.thTH,
      thThCount: base.thThCount,
      thThSugCount: base.thThSugCount,
      jpJP: base.jpJP,
      jpJPCount: base.jpJPCount,
      jpJPSubCount: base.jpJPSubCount,
      krKR: base.krKR,
      krKRCount: base.krKRCount,
      krKRSugCount: base.krKRSugCount,
      vnVN: base.vnVN,
      vnVNCount: base.vnVNCount,
      vnVNSugCount: base.vnVNSugCount,
      jsonKey: from.jsonKey,
    );
  }
}
