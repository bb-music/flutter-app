import 'dart:convert';

import 'package:flutter_app/modules/user_music_order/local/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../common.dart';

const uuid = Uuid();

class UserMusicOrderForLocal implements UserMusicOrderOrigin {
  @override
  String name = LocalOriginConst.name;
  @override
  final String cname = LocalOriginConst.cname;
  @override
  final IconData icon = Icons.folder;

  Future<List<MusicOrderItem>> _loadData() async {
    final localStorage = await SharedPreferences.getInstance();
    final str = localStorage.getString(LocalOriginConst.cacheKey) ?? '[]';
    final res = json.decode(str);

    final List<MusicOrderItem> list = [];
    for (var item in res) {
      list.add(MusicOrderItem.fromJson(item));
    }
    return list;
  }

  @override
  configBuild() {
    return null;
  }

  @override
  canUse() {
    return true;
  }

  @override
  initConfig() async {}

  @override
  Future<List<MusicOrderItem>> getList() async {
    if (!canUse()) {
      return [];
    }
    final res = await _loadData();
    return res;
  }

  @override
  Future<void> create(data) async {
    final list = await _loadData();

    // 判断歌单是否已存在
    if (list.where((e) => e.name == data.name).isNotEmpty) {
      throw Exception('歌单已存在');
    }
    String id = uuid.v4();
    list.add(
      MusicOrderItem(
        id: id,
        name: data.name,
        cover: data.cover,
        desc: data.desc,
        author: data.author,
        musicList: data.musicList,
      ),
    );

    await _update(list);
  }

  Future<void> _update(List<MusicOrderItem> list) async {
    final localStorage = await SharedPreferences.getInstance();
    final jsonStr = json.encode(list);
    await localStorage.setString(LocalOriginConst.cacheKey, jsonStr);
  }

  @override
  Future<void> update(data) async {
    final list = await _loadData();
    final index = list.indexWhere((e) => e.id == data.id);
    final current = list[index];
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: data.name,
      cover: data.cover,
      desc: data.desc,
      author: data.author,
      musicList: current.musicList,
    );

    return _update(list);
  }

  @override
  Future<void> delete(data) async {
    final list = await _loadData();
    final index = list.indexWhere((e) => e.id == data.id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    list.removeAt(index);
    return _update(list);
  }
}
