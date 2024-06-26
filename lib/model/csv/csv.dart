/// 語系區分
enum LangEnum { en, tw, cn, jp, kr, th, vi, hi_IN }

const List<dynamic> titleRow = [
  'zh_TW',
  'zh-CN',
  'en-En',
  'en手動調整',
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
  'hi_IN',
  '印度字數',
  '建議字數',
  'jsonKey'
];

class CsvData {
  /// csv標準格式，逗號分隔值
  static const String csvStandard = ',';

  // TODO 測試key，有錯直街用zhTw
  String get containsTwKey => zhTW.trim().replaceAll('\n', '').replaceAll('\r', '').replaceAll(' ', '');

  /// 繁中
  final String zhTW;

  /// 簡中
  final String zhCN;

  /// 英文
  final String enEN;

  /// 手動調整後的英文
  final String enEnAdjust;

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

  /// 越南文
  final String hi_IN;

  /// 越南文字數
  final String indCount;

  /// 越南文建議字數
  final String indSugCount;

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
    required this.enEnAdjust,
    required this.hi_IN,
    required this.indCount,
    required this.indSugCount,
  });

  factory CsvData.fromRow(List<String> row) {
    return CsvData(
      zhTW: row[0],
      zhCN: row[1],
      enEN: row[2],
      enEnAdjust: row[3],
      enEnCount: '',
      enEnSugCount: '',
      thTH: row[4],
      thThCount: row[5],
      thThSugCount: row[6],
      jpJP: row[7],
      jpJPCount: row[8],
      jpJPSubCount: row[9],
      krKR: row[10],
      krKRCount: row[11],
      krKRSugCount: row[12],
      vnVN: row[13],
      vnVNCount: row[14],
      vnVNSugCount: row[15],
      hi_IN: row[16],
      indCount: row[17],
      indSugCount: row[18],
      jsonKey: row[19].split(csvStandard),
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
    String hi_IN = '';

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
      case LangEnum.hi_IN:
        hi_IN = value;
        break;
    }

    return CsvData(
      zhTW: zhTW,
      zhCN: zhCN,
      enEN: enEN,
      enEnAdjust: '',
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
      hi_IN: hi_IN,
      indCount: '',
      indSugCount: '',
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
    CsvData? hi_IN,
  }) {
    return CsvData(
      zhTW: tw.zhTW,
      zhCN: cn?.zhCN ?? '',
      enEN: en?.enEN ?? '',
      enEnAdjust: en?.enEnAdjust ?? en?.enEN ?? '',
      enEnCount: '',
      enEnSugCount: '',
      thTH: th?.thTH ?? '',
      thThCount: '',
      thThSugCount: '',
      jpJP: jp?.jpJP ?? '',
      jpJPCount: '',
      jpJPSubCount: '',
      krKR: kr?.krKR ?? '',
      krKRCount: '',
      krKRSugCount: '',
      vnVN: vi?.vnVN ?? '',
      vnVNCount: '',
      vnVNSugCount: '',
      // vnVNSugCount: getSuggestCount(tw.zhTW, LangEnum.vi),
      hi_IN: hi_IN?.hi_IN ?? '',
      indCount: '',
      indSugCount: '',
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
        case LangEnum.hi_IN:
          return text.length;
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
      enEnAdjust,
      // TODO 暫時拿掉
      // enEnCount,
      // enEnSugCount,
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
      hi_IN,
      indCount,
      indSugCount,
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
        return enEnAdjust.isEmpty ? enEN : enEnAdjust;
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
      case LangEnum.hi_IN:
        return hi_IN;
    }
  }

  Map<String, dynamic> _parentList(List<String> spKeys, String value) {
    Map<String, dynamic> map = {};

    if (value.isEmpty) {
      return map;
    }

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
      zhCN: from.zhCN.isNotEmpty ? from.zhCN : base.zhCN,
      enEN: from.enEN.isNotEmpty ? from.enEN : base.enEN,
      enEnAdjust: base.enEnAdjust,
      enEnSugCount: base.enEnSugCount,
      enEnCount: base.enEnCount,
      thTH: from.thTH.isNotEmpty ? from.thTH : base.thTH,
      thThCount: base.thThCount,
      thThSugCount: base.thThSugCount,
      jpJP: from.jpJP.isNotEmpty ? from.jpJP : base.jpJP,
      jpJPCount: base.jpJPCount,
      jpJPSubCount: base.jpJPSubCount,
      krKR: from.krKR.isNotEmpty ? from.krKR : base.krKR,
      krKRCount: base.krKRCount,
      krKRSugCount: base.krKRSugCount,
      vnVN: from.vnVN.isNotEmpty ? from.vnVN : base.vnVN,
      vnVNCount: base.vnVNCount,
      vnVNSugCount: base.vnVNSugCount,
      hi_IN: from.hi_IN.isNotEmpty ? from.hi_IN : base.hi_IN,
      indCount: base.indCount,
      indSugCount: base.indSugCount,
      jsonKey: from.jsonKey,
    );
  }
}
