import 'dart:async';
import 'dart:convert';

import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:bbmusic/modules/user_music_order/user_music_order.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class MusicOrderOriginSettingModel extends ChangeNotifier {
  List<OriginSettingItem> list = [];
  Timer? _timer;

  List<UserMusicOrderOriginItem> userMusicOrderList = [];

  init() async {
    await load();
    await initUserMusicOrderList();
  }

  // 加载源配置列表
  load() async {
    final localStorage = await SharedPreferences.getInstance();
    final jsonStr = localStorage.getString(CacheKey.cloudMusicOrderSetting);
    list.clear();
    if (jsonStr != null) {
      List<dynamic> _list = jsonDecode(jsonStr);
      list.addAll(_list.where((t) => t['name'] != LocalOriginConst.name).map(
        (l) {
          return OriginSettingItem(
            id: l['id'],
            name: l['name'],
            subName: l['sub_name'] ?? '',
            config: l['config'],
          );
        },
      ));
    }
    // 插入到数组首位
    list.insert(
      0,
      OriginSettingItem(
        id: LocalOriginConst.name,
        name: LocalOriginConst.name,
        subName: LocalOriginConst.cname,
        config: {},
      ),
    );
  }

  // 更新源配置列表
  void update(String id, String subName, Map<String, dynamic> config) async {
    for (var l in list) {
      if (l.id == id) {
        l.subName = subName;
        l.config = config;
      }
    }
    _updateLocalStorage();
    notifyListeners();
  }

  // 新增源配置
  void add(String name, String subName, Map<String, dynamic> config) async {
    list.add(OriginSettingItem(
      name: name,
      id: uuid.v4(),
      subName: subName,
      config: config,
    ));
    _updateLocalStorage();
    notifyListeners();
  }

  // 删除源配置
  void delete(String id) async {
    list.removeWhere((o) => o.id == id);
    _updateLocalStorage();
    notifyListeners();
  }

  // 更新缓存
  void _updateLocalStorage() {
    _timer?.cancel();
    _timer = Timer(const Duration(microseconds: 500), () async {
      final localStorage = await SharedPreferences.getInstance();
      String listStr = jsonEncode(list);
      localStorage.setString(CacheKey.cloudMusicOrderSetting, listStr);
      initUserMusicOrderList();
    });
  }

  OriginSettingItem? id2OriginInfo(String id) {
    return list.firstWhere((o) => o.id == id);
  }

  // 初始化用户歌单列表
  initUserMusicOrderList() async {
    userMusicOrderList.clear();
    for (var s in list) {
      final umo = userMusicOrderOrigin[s.name];
      if (umo != null) {
        userMusicOrderList.add(
          UserMusicOrderOriginItem(
            id: s.id,
            service: umo(),
          ),
        );
      }
    }
    await Future.wait(userMusicOrderList.map((s) => _loadItem(s)));
  }

  // 重载单个源的列表
  loadSignal(String id) async {
    final current = userMusicOrderList.firstWhere((d) => d.id == id);
    final info = id2OriginInfo(id);
    if (current == null || info == null) return;
    await _loadItem(current);
  }

  // 根据配置加载歌单列表
  Future<void> _loadItem(UserMusicOrderOriginItem umo) async {
    umo.loading = true;
    try {
      final config = id2OriginInfo(umo.id)?.config;
      await umo.service.initConfig(config ?? {});
      umo.list = umo.service.getList();
    } catch (e) {
      BotToast.showText(text: "加载失败");
      rethrow;
    }
    umo.loading = true;
    notifyListeners();
  }
}

class OriginSettingItem {
  final String name;
  final String id;
  String subName;
  Map<String, dynamic> config;

  OriginSettingItem({
    required this.name,
    required this.id,
    required this.subName,
    required this.config,
  });

  /// 转换为JSON字符串
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'sub_name': subName,
      'config': config,
    };
  }

  /// 从JSON字符串转换
  factory OriginSettingItem.fromJson(Map<String, dynamic> json) {
    return OriginSettingItem(
      name: json['name'],
      id: json['id'],
      subName: json['sub_name'] ?? '',
      config: json['config'],
    );
  }
}

Future<List<MusicOrderItem>> initializeList() async {
  await Future.delayed(const Duration(seconds: 0));
  List<MusicOrderItem> initialItems = [];
  return initialItems;
}

class UserMusicOrderOriginItem {
  String id;
  bool loading = false;
  Future<List<MusicOrderItem>>? list = initializeList();
  final UserMusicOrderOrigin service;
  UserMusicOrderOriginItem({
    this.loading = false,
    this.list,
    required this.id,
    required this.service,
  });
}
