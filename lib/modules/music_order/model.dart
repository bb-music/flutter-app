import 'package:flutter/material.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/modules/user_music_order/user_music_order.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';

final _defaultDataList = userMusicOrderOrigin
    .map((e) => UserMusicOrderOriginItem(
          service: e,
        ))
    .toList();

class UserMusicOrderModel extends ChangeNotifier {
  final List<UserMusicOrderOriginItem> dataList = _defaultDataList;

  init() async {
    await Future.wait(
      dataList.map((s) => _loadItem(s)),
    );
  }

  // 重载单个源的列表
  load(String originName) async {
    final index = dataList.indexWhere((d) => d.service.name == originName);
    if (index < 0) return;
    final current = dataList[index];
    await _loadItem(current);
    notifyListeners();
  }

  Future<void> _loadItem(
    UserMusicOrderOriginItem umo,
  ) async {
    umo.loading = true;
    try {
      await umo.service.initConfig();
      umo.list = umo.service.getList();
    } catch (e) {
      rethrow;
    }
    umo.loading = true;
    notifyListeners();
  }
}

Future<List<MusicOrderItem>> initializeList() async {
  await Future.delayed(const Duration(seconds: 0));
  List<MusicOrderItem> initialItems = [];
  return initialItems;
}

class UserMusicOrderOriginItem {
  bool loading = false;
  Future<List<MusicOrderItem>>? list = initializeList();
  final UserMusicOrderOrigin service;
  UserMusicOrderOriginItem({
    this.loading = false,
    this.list,
    required this.service,
  });
}
