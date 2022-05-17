class CsvData {
  /// 繁中
  final String zhTW;

  /// 簡中
  final String zhCN;

  /// 英文
  final String enEN;

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

  CsvData._({
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
  });

  factory CsvData.fromRow(List<String> row) {
    return CsvData._(
      zhTW: row[0],
      zhCN: row[1],
      enEN: row[2],
      thTH: row[3],
      thThCount: row[4],
      thThSugCount: row[5],
      jpJP: row[6],
      jpJPCount: row[7],
      jpJPSubCount: row[8],
      krKR: row[9],
      krKRCount: row[10],
      krKRSugCount: row[11],
      vnVN: row[12],
      vnVNCount: row[13],
      vnVNSugCount: row[14],
      jsonKey: row[15].split(","),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return jsonKey.map((e) {
      var sp = e.split(".");
      return _parentList(sp, zhTW);
    }).toList();
  }

  Map<String, dynamic> _parentList(List<String> spKeys, String value) {
    Map<String, dynamic> map = {};
    if (spKeys.length == 1) {
      return {spKeys.first: value};
    }

    // for (var i = 0; i < spKeys.length; i++) {
    String parentKey = spKeys.first;
    map[spKeys.first] = _childList({}, spKeys.sublist(1).join("."), value, parentKey);
    // }
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
}
