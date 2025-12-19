import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// Generate HMAC-SHA256 signature
/// [key] The key string to use for the HMAC-SHA256 hash
/// [message] The message string to hash
/// Returns The HMAC-SHA256 signature as a hex string
String hmacSha256(String key, String message) {
  final hmac = Hmac(sha256, utf8.encode(key));
  final digest = hmac.convert(utf8.encode(message));
  return digest.toString();
}

/// Get Bilibili web ticket
/// [csrf] CSRF token, can be empty or null
/// Returns Promise of the ticket response in JSON format
Future<String> getBiliTicket(String? csrf) async {
  final ts = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  final hexSign = hmacSha256('XgwSnGZ1p', 'ts$ts');
  const url =
      'https://api.bilibili.com/bapis/bilibili.api.ticket.v1.Ticket/GenWebTicket';

  final params = {
    'key_id': 'ec02',
    'hexsign': hexSign,
    'context[ts]': ts.toString(),
    'csrf': csrf ?? '',
  };

  final dio = Dio();
  final response = await dio.post(
    url,
    queryParameters: params,
    options: Options(
      headers: {
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0',
      },
    ),
  );

  if (response.statusCode == null ||
      response.statusCode! < 200 ||
      response.statusCode! >= 300) {
    throw Exception('HTTP error! status: ${response.statusCode}');
  }

  if (response.data is Map<String, dynamic>) {
    return response.data['data']['ticket'] as String;
  } else if (response.data is String) {
    final res = jsonDecode(response.data) as Map<String, dynamic>;
    if (res['code'] == 0) {
      return res['data']['ticket'] as String;
    } else {
      throw Exception('Bilibili API error! code: ${res['code']}');
    }
  } else {
    throw Exception('Unexpected response type: ${response.data.runtimeType}');
  }
}
