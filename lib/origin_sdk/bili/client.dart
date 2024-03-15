import 'package:http/http.dart' as http;
import 'dart:convert';
import './sign.dart';
import './types.dart';

class BiliClient {
  SignData? signData;
  SpiData? spiData;

  // 获取签名秘钥
  Future<SignData> getSignData() async {
    final response = await http.get(
      Uri.parse('https://api.bilibili.com/x/web-interface/nav'),
    );

    if (response.statusCode == 200) {
      return SignData.fromJson(json.decode(response.body));
    } else {
      throw Exception('获取哔哩哔哩签名秘钥失败');
    }
  }

  // 获取 spi 唯一标识
  Future<SpiData> getSpiData() async {
    final response = await http.get(
      Uri.parse('https://api.bilibili.com/x/frontend/finger/spi'),
    );

    if (response.statusCode == 200) {
      return SpiData.fromJson(json.decode(response.body));
    } else {
      throw Exception('获取哔哩哔哩 spi 唯一标识失败');
    }
  }

  // 对参数进行签名
  signParams(Map<String, String> params) {
    if (signData == null) {
      throw Exception('请先获取签名秘钥');
    }
    return encWbi(params, signData!.imgKey, signData!.subKey);
  }

  // 搜索
  search(SearchParams params) {}
}
