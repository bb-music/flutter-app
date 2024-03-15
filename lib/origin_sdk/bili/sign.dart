import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

final List<int> mixinKeyEncTab = [
  46,
  47,
  18,
  2,
  53,
  8,
  23,
  32,
  15,
  50,
  10,
  31,
  58,
  3,
  45,
  35,
  27,
  43,
  5,
  49,
  33,
  9,
  42,
  19,
  29,
  28,
  14,
  39,
  12,
  38,
  41,
  13,
  37,
  48,
  7,
  16,
  24,
  55,
  40,
  61,
  26,
  17,
  0,
  1,
  60,
  51,
  30,
  4,
  22,
  25,
  54,
  21,
  56,
  59,
  6,
  63,
  57,
  62,
  11,
  36,
  20,
  34,
  44,
  52
];

String getMixinKey(String orig) {
  return mixinKeyEncTab.map((n) => orig[n]).join('').substring(0, 32);
}

Map<String, dynamic> encWbi(
    Map<String, dynamic> params, String imgKey, String subKey) {
  String mixinKey = getMixinKey(imgKey + subKey);
  int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  RegExp chrFilter = RegExp(r"[!'()*]");

  params['wts'] = currentTime.toString();

  var newParams = params.keys.toList();
  newParams.sort();
  String query = newParams.map((key) {
    String value = params[key].toString().replaceAll(chrFilter, '');
    return '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}';
  }).join('&');

  String wbiSign = crypto.md5.convert(utf8.encode(query + mixinKey)).toString();
  params['w_rid'] = wbiSign;
  return params;
}
