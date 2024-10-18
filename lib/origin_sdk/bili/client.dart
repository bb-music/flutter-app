import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:bbmusic/origin_sdk/bili/utils.dart';
import 'package:bbmusic/utils/logs.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final dio = Dio();

  SignData? signData;
  SpiData? spiData;

  BiliClient() {
    dio.options.headers["UserAgent"] = _userAgent;
    dio.options.headers["Referer"] = "https://www.bilibili.com/";
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          if (spiData?.b4 != null && spiData?.b3 != null) {
            final cookie = "buvid4=${spiData!.b4}; buvid3=${spiData!.b3};";
            options.headers["cookie"] = cookie;
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          BotToast.showText(text: '请求失败: $error');
          return handler.next(error);
        },
      ),
    );
  }

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
    final response =
        await dio.get("https://api.bilibili.com/x/web-interface/nav");

    if (response.statusCode == 200) {
      return SignData.fromJson(response.data);
    } else {
      logs.e("bili: 获取签名秘钥失败", error: {"body": response.data});
      throw response.data;
    }
  }

  // 获取 spi 唯一标识
  Future<SpiData> getSpiData() async {
    final response =
        await dio.get("https://api.bilibili.com/x/frontend/finger/spi");

    if (response.statusCode == 200) {
      return SpiData.fromJson(response.data);
    } else {
      logs.e("bili: 获取 spi 唯一标识失败", error: {"body": response.data});
      throw response.data;
    }
  }

  // 搜索
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
    final response = await dio.get(
      Uri.parse(url).replace(queryParameters: query).toString(),
    );

    if (response.statusCode == 200) {
      return BiliSearchResponse.fromJson(response.data);
    } else {
      logs.e(
        "bili: 搜索失败",
        error: {"body": response.data, 'params': params},
      );
      throw response.data;
    }
  }

  // 搜索条目详情
  @override
  Future<SearchItem> searchDetail(String id) async {
    BiliId biliid = BiliId.unicode(id);
    await init();
    const url = 'https://api.bilibili.com/x/web-interface/view';
    Map<String, String> query = _signParams({
      'aid': biliid.aid,
      'bvid': biliid.bvid,
    });
    final response = await dio.get(
      Uri.parse(url).replace(queryParameters: query).toString(),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'];
      return BiliSearchItem.fromJson(data);
    } else {
      logs.e(
        "bili: 搜索条目详情获取失败",
        error: {"body": response.data, 'id': id},
      );
      throw response.data;
    }
  }

  // 搜索建议
  @override
  Future<List<SearchSuggestItem>> searchSuggest(String keyword) async {
    await init();
    const url = 'https://s.search.bilibili.com/main/suggest';
    Map<String, String> query = _signParams({
      'term': keyword,
    });
    final response = await dio.get(
      Uri.parse(url).replace(queryParameters: query).toString(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> tags = jsonDecode(response.data)['result']['tag'];
      List<SearchSuggestItem> result = [];
      tags.toList().forEach((t) {
        result.add(SearchSuggestItem(name: t['name'], value: t['value']));
      });
      return result;
    } else {
      logs.e(
        "bili: 搜索条目详情获取失败",
        error: {"body": response.data, 'keyword': keyword},
      );
      throw response.data;
    }
  }

  // 获取音乐播放地址
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
      'fnval': '4048'
    });
    final response = await dio.get(
      Uri.parse(url).replace(queryParameters: query).toString(),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'];
      List<dynamic> audioList = data['dash']['audio'].toList();
      // 排序，取带宽最大的音质最高
      audioList.sort((a, b) => b['bandwidth'].compareTo(a['bandwidth']));
      String url = audioList[0]['baseUrl'];
      print(audioList);
      return MusicUrl(
        url: url,
        headers: {'Referer': _referer},
      );
    } else {
      logs.e(
        "bili: 获取音乐播放地址失败",
        error: {"body": response.data, 'id': id},
      );
      throw response.data;
    }
  }

  // 对参数进行签名
  _signParams(Map<String, String> params) {
    if (signData == null) {
      throw Exception('请先获取签名秘钥');
    }
    return encWbi(params, signData!.imgKey, signData!.subKey);
  }
}
