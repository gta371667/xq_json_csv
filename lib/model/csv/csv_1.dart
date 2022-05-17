class CsvData1 {
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

  CsvData1._({
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

  factory CsvData1.fromRow(List<String> row) {
    return CsvData1._(
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
      // return _bbb(e, zhTW) as Map<String, dynamic>;
    }).toList();

    // if (jsonKey.length == 1 && jsonKey.first.split(".").length == 1) {
    //   map.addAll(_keyToMap(jsonKey.first.split("."), zhTW));
    //   // return _keyToMap(jsonKey.first.split("."), zhTW);
    // } else {
    //   // return _keyToMap(jsonKey, zhTW);
    //   map.addAll(_keyToMap(jsonKey, zhTW));
    // }

    // return map;
  }

  Map<String, dynamic> _parentList(List<String> spKeys, String value) {
    Map<String, dynamic> map = {};
    if (spKeys.length == 1) {
      return {spKeys.first: value};
    }

    for (var i = 0; i < spKeys.length; i++) {
      String parentKey = spKeys[i];
      _childList(map, spKeys.sublist(i + 1).join("."), value, parentKey);

      // if (data is String) {
      //   map[parentKey] = data;
      // } else {
      //   // map[parentKey] = data;
      // }

      // if (map.isEmpty) {
      //   map[parentKey] = _childList(map, spKeys.sublist(i + 1).join("."), value, parentKey);
      // } else {
      //   map[spKeys.first] = _childList(map, spKeys.sublist(i + 1).join("."), value, parentKey);
      // }

      // map.addAll({
      //   spKeys[i]: _bbb(spKeys[i], value),
      // });
    }
    return map;
  }

  dynamic _childList(Map<String, dynamic> map, String key, value, String parentKey) {
    if (key.isEmpty) return value;

    var sp = key.split(".");

    for (var i = 0; i < sp.length; i++) {
      // if (map.isEmpty) {
      //   map[sp.first] = _childList(map, sp.sublist(i + 1).join("."), value, parentKey);
      // } else {
      //   map[sp[i]] = _childList(map, sp.sublist(i + 1).join("."), value, parentKey);
      // }

      if (map.isEmpty) {
        map.addAll({
          sp[i]: _childList({}, sp.sublist(i + 1).join("."), value, sp[i]),
        });
      }
    }

    return map;
  }

  Map<String, dynamic> _keyToMap(List<String> keys, String value) {
    Map<String, dynamic> map = {};

    for (var i = 0; i < keys.length; i++) {
      var sp = keys[i].split(".");

      map.addAll({sp.first: _aaaa(sp.sublist(i), value)});
      // for (var i = 0; i < sp.length; i++) {
      //   final valueData = sp.sublist(i);
      //   map.addAll({sp.first: _aaaa(valueData, value)});
      // }
    }

    // if (keys.length == 1 && keys.first.split(".").length == 1) {
    //   return {keys.first: value};
    // } else {
    //   return {keys.first.split(".").first: _keyToMap(keys.first.split(".").sublist(1), value)};
    // }

    return map;
  }

  dynamic _aaaa(List<String> keys, String value) {
    Map<String, dynamic> map = {};

    for (var i = 0; i < keys.length; i++) {
      final valueData = keys.sublist(i + 1);
      map.addAll({keys.first: _aaaa(valueData, value)});
    }

    // if (keys.length == 1 && keys.first.split(".").length == 1) {
    //   return {keys.first: value};
    // } else {
    //   return {keys.first.split(".").first: _keyToMap(keys.first.split(".").sublist(1), value)};
    // }

    return map;
  }

// Map<String, dynamic> toJson() {
//   Map<String, dynamic> map = {};
//
//   if (jsonKey.length == 1 && jsonKey.first.split(".").length == 1) {
//     map.addAll(_keyToMap(jsonKey.first.split("."), zhTW));
//     // return _keyToMap(jsonKey.first.split("."), zhTW);
//   } else {
//     // return _keyToMap(jsonKey, zhTW);
//     map.addAll(_keyToMap(jsonKey, zhTW));
//   }
//
//   return map;
// }
//
// Map<String, dynamic> _keyToMap(List<String> keys, String value) {
//   Map<String, dynamic> map = {};
//
//   for (var i = 0; i < keys.length; i++) {
//     var sp = keys[i].split(".");
//
//     map.addAll({sp.first: _aaaa(sp.sublist(i), value)});
//     // for (var i = 0; i < sp.length; i++) {
//     //   final valueData = sp.sublist(i);
//     //   map.addAll({sp.first: _aaaa(valueData, value)});
//     // }
//   }
//
//   // if (keys.length == 1 && keys.first.split(".").length == 1) {
//   //   return {keys.first: value};
//   // } else {
//   //   return {keys.first.split(".").first: _keyToMap(keys.first.split(".").sublist(1), value)};
//   // }
//
//   return map;
// }
//
// Map<String, dynamic> _aaaa(List<String> keys, String value) {
//   Map<String, dynamic> map = {};
//
//   for (var i = 0; i < keys.length; i++) {
//     final valueData = keys.sublist(i+1);
//     map.addAll({keys.first: _aaaa(valueData, value)});
//   }
//
//   // if (keys.length == 1 && keys.first.split(".").length == 1) {
//   //   return {keys.first: value};
//   // } else {
//   //   return {keys.first.split(".").first: _keyToMap(keys.first.split(".").sublist(1), value)};
//   // }
//
//   return map;
// }
}
