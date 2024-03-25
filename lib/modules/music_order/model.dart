import 'package:flutter/material.dart';
import 'package:flutter_app/modules/user_music_order/common.dart';
import 'package:flutter_app/modules/user_music_order/user_music_order.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';

class UserMusicOrderModel extends ChangeNotifier {
  final List<UserMusicOrderOriginItem> dataList = [];

  init() async {
    dataList.clear();
    final res = await Future.wait(
      userMusicOrderOrigin.map((s) => _loadItem(s)),
    );
    dataList.addAll(res);
    notifyListeners();
  }

  // 重载单个源的列表
  load(String originName) async {
    final index = dataList.indexWhere((d) => d.service.name == originName);
    if (index < 0) {
      return;
    }
    final current = dataList[index];
    final service = current.service;
    final newList = await service.getList();
    current.list.clear();
    current.list.addAll(newList);
    notifyListeners();
  }

  Future<UserMusicOrderOriginItem> _loadItem(
    UserMusicOrderOrigin service,
  ) async {
    await service.initConfig();
    final list = await service.getList();
    return UserMusicOrderOriginItem(service: service, list: list);
  }
}

class UserMusicOrderOriginItem {
  final UserMusicOrderOrigin service;
  final List<MusicOrderItem> list;
  const UserMusicOrderOriginItem({required this.service, required this.list});
}
