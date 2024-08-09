import 'package:bbmusic/modules/open_music_order/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';

final dio = Dio();

class OpenMusicOrderModel extends ChangeNotifier {
  final List<MusicOrderItem> dataList = [];
  bool loading = true;
  final dio = Dio();

  // 加载
  Future<void> load() async {
    dataList.clear();
    final List<String> urls = await getMusicOrderUrl();
    // 并发请求多个接口
    await Future.wait(urls.map(_getOrder));
    loading = false;
    notifyListeners();
  }

  Future<void> reload() async {
    loading = true;
    notifyListeners();
    await load();
  }

  // 获取歌单
  Future<void> _getOrder(String url) async {
    try {
      final res = await dio.get(url);
      if (res.statusCode == 200) {
        final data = res.data;
        final List<MusicOrderItem> l = [];
        data.forEach((item) {
          l.add(MusicOrderItem.fromJson(item));
        });
        dataList.addAll(l);
      }
    } catch (e) {
      print(e);
      BotToast.showSimpleNotification(title: "歌单源错误");
    }
  }
}
