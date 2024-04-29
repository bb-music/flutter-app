import 'package:bot_toast/bot_toast.dart';
import 'package:bbmusic/origin_sdk/bili/utils.dart';
import 'package:bbmusic/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../origin_types.dart';
import './sign.dart';
import './types.dart';

const _userAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";
const _referer = "https://www.bilibili.com/";
const _cacheCreatedAtKey = "bili_catch_created_at";
const _signImgKey = "bili_sign_img_key";
const _signSubKey = "bili_sign_sub_key";
const _spiB3 = "bili_spi_b3";
const _spiB4 = "bili_spi_b4";

class BiliClient implements OriginService {
  SignData? signData;
  SpiData? spiData;

  init() async {
    final localStorage = await SharedPreferences.getInstance();
    final createAt = localStorage.getInt(_cacheCreatedAtKey);

    if (createAt != null) {
      if (DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(createAt))
              .inDays <
          1) {
        final signImgKey = localStorage.getString(_signImgKey);
        final signSubKey = localStorage.getString(_signSubKey);
        final spiB3 = localStorage.getString(_spiB3);
        final spiB4 = localStorage.getString(_spiB4);
        if (signSubKey != null &&
            signImgKey != null &&
            spiB3 != null &&
            spiB4 != null) {
          signData = SignData(imgKey: signImgKey, subKey: signSubKey);
          spiData = SpiData(b3: spiB3, b4: spiB4);
          return;
        }
      }
    }

    final results = await Future.wait([getSignData(), getSpiData()]);

    signData = results[0] as SignData;
    spiData = results[1] as SpiData;
    localStorage.setInt(
        _cacheCreatedAtKey, DateTime.now().millisecondsSinceEpoch);
    if (signData != null) {
      localStorage.setString(_signImgKey, signData!.imgKey);
      localStorage.setString(_signSubKey, signData!.subKey);
    }
    if (spiData != null) {
      localStorage.setString(_spiB3, spiData!.b3);
      localStorage.setString(_spiB4, spiData!.b4);
    }
  }

  // 获取签名秘钥
  Future<SignData> getSignData() async {
    final response = await http.get(
      Uri.parse('https://api.bilibili.com/x/web-interface/nav'),
    );

    if (response.statusCode == 200) {
      return SignData.fromJson(json.decode(response.body));
    } else {
      logs.e("bili: 获取签名秘钥失败", error: {"body": response.body});
      throw response.body;
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
      logs.e("bili: 获取 spi 唯一标识失败", error: {"body": response.body});
      throw response.body;
    }
  }

  @override
  Future<SearchResponse> search(SearchParams params) async {
    await init();
    const url = 'https://api.bilibili.com/x/web-interface/wbi/search/type';
    Map<String, String> query = _signParams({
      'search_type': 'video',
      'keyword': params.keyword,
      'page': params.page.toString(),
      'pagesize': '20',
    });
    final response = await _request(
      Uri.parse(url).replace(queryParameters: query),
    );

    if (response.statusCode == 200) {
      return BiliSearchResponse.fromJson(json.decode(response.body));
    } else {
      logs.e(
        "bili: 搜索失败",
        error: {"body": response.body, 'params': params},
      );
      throw response.body;
    }
  }

  @override
  Future<SearchItem> searchDetail(String id) async {
    BiliId biliid = BiliId.unicode(id);
    await init();
    const url = 'https://api.bilibili.com/x/web-interface/view';
    Map<String, String> query = _signParams({
      'aid': biliid.aid,
      'bvid': biliid.bvid,
    });
    final response = await _request(
      Uri.parse(url).replace(queryParameters: query),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return BiliSearchItem.fromJson(data);
    } else {
      logs.e(
        "bili: 搜索条目详情获取失败",
        error: {"body": response.body, 'id': id},
      );
      throw response.body;
    }
  }

  @override
  Future<MusicUrl> getMusicUrl(String id) async {
    BiliId biliid = BiliId.unicode(id);
    if (biliid.cid == null || biliid.cid == '') {
      // 歌曲 ID 不正确 缺少 CID
      logs.e("bili: 歌曲 ID 不正确 缺少 CID", error: {
        "id": id,
        "biliid": biliid,
      });
      throw Exception('歌曲 ID 不正确 缺少 CID');
    }
    await init();
    const url = 'https://api.bilibili.com/x/player/wbi/playurl';
    Map<String, String> query = _signParams({
      'aid': biliid.aid,
      'bvid': biliid.bvid,
      'cid': biliid.cid!,
    });

    final response = await _request(
      Uri.parse(url).replace(queryParameters: query),
    );

    if (response.statusCode == 200) {
      final res = json.decode(response.body)['data'];
      final durl = res['durl'].toList();
      String url = '';
      if (durl != null && durl.isNotEmpty) {
        url = durl[0]['url'];
      }
      return MusicUrl(
        url: url,
        headers: {'Referer': _referer},
      );
    } else {
      logs.e(
        "bili: 获取音乐播放地址失败",
        error: {"body": response.body, 'id': id},
      );
      throw response.body;
    }
  }

  // 对参数进行签名
  _signParams(Map<String, String> params) {
    if (signData == null) {
      throw Exception('请先获取签名秘钥');
    }
    return encWbi(params, signData!.imgKey, signData!.subKey);
  }

  /// 请求封装
  Future<http.Response> _request(Uri uri) async {
    try {
      return await http.get(
        uri,
        headers: {
          "UserAgent": _userAgent,
          "cookie": "buvid4=${spiData!.b4}; buvid3=${spiData!.b3};",
          "Referer": "https://www.bilibili.com/"
        },
      );
    } catch (e) {
      BotToast.showText(text: '请求失败: $e');
      throw Exception('请求失败: $e');
    }
  }
}
