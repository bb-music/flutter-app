import 'dart:async';
import 'dart:convert';

import 'package:bbmusic/database/database.dart';
import 'package:bbmusic/database/uuid.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:bbmusic/modules/user_music_order/user_music_order.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class MusicOrderOriginSettingModel extends ChangeNotifier {
  List<OriginSettingItem> list = [];
  bool isInit = false;
  final db = AppDatabase();

  List<UserMusicOrderOriginItem> userMusicOrderList = [];

  init() async {
    if (isInit) {
      return;
    }
    await load();
    await initUserMusicOrderList();
    isInit = true;
  }

  // 加载源配置列表
  load() async {
    // 云端歌单源
    final cloudList = await db.managers.cloudMusicOrderEntity.get();
    list.clear();
    list.addAll(cloudList.where((t) => t.origin != LocalOriginConst.name).map(
      (l) {
        return OriginSettingItem(
          id: l.id.toString(),
          name: l.origin,
          subName: l.subName ?? '',
          config: jsonDecode(l.config ?? '{}'),
        );
      },
    ));
    // 本地歌单源列表
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
    await db.managers.cloudMusicOrderEntity
        .filter((f) => f.id.equals(id))
        .update((o) {
      return o(
        subName: Value(subName),
        config: Value(jsonEncode(config)),
      );
    });
    await load();
    await initUserMusicOrderList();
    notifyListeners();
  }

  // 新增源配置
  void add(String name, String subName, Map<String, dynamic> config) async {
    await db.managers.cloudMusicOrderEntity.create((o) {
      return o(
        id: generateUUID(),
        origin: name,
        subName: subName,
        config: jsonEncode(config),
      );
    });
    await load();
    await initUserMusicOrderList();
    notifyListeners();
  }

  // 删除源配置
  void delete(String id) async {
    await db.managers.cloudMusicOrderEntity
        .filter((f) => f.id.equals(id))
        .delete();
    await load();
    await initUserMusicOrderList();
    notifyListeners();
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
    if (info == null) return;
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
