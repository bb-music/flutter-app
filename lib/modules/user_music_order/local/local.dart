import 'dart:convert';

import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
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
  canUse() {
    return true;
  }

  @override
  Widget? configBuild({
    Map<String, dynamic>? value,
    required Function(Map<String, dynamic>) onChange,
  }) {
    return null;
  }

  @override
  initConfig(config) async {}

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
    await updateLocalMusicOrderData(list);
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

  @override
  getDetail(id) async {
    final list = await getList();
    final index = list.indexWhere((r) => r.id == id);
    if (index < 0) {
      throw Exception("歌单不存在");
    }
    return list[index];
  }

  @override
  appendMusic(id, musics) async {
    final list = await _loadData();
    final index = list.indexWhere((e) => e.id == id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    final current = list[index];
    List<String> mids = musics.map((e) => e.id).toList();
    current.musicList.removeWhere((m) => mids.contains(m.id));
    current.musicList.addAll(musics);

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: current.name,
      cover: current.cover,
      desc: current.desc,
      author: current.author,
      musicList: current.musicList,
    );

    return _update(list);
  }

  @override
  updateMusic(id, musics) async {
    final list = await _loadData();
    final index = list.indexWhere((e) => e.id == id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    final current = list[index];
    List<String> mids = musics.map((e) => e.id).toList();

    final newList = current.musicList.map((m) {
      if (mids.contains(m.id)) {
        final c = musics.firstWhere((e) => e.id == m.id);
        return MusicItem(
          name: c.name,
          cover: m.cover,
          id: m.id,
          duration: m.duration,
          author: m.author,
          origin: m.origin,
        );
      }
      return m;
    }).toList();

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: current.name,
      cover: current.cover,
      desc: current.desc,
      author: current.author,
      musicList: newList,
    );

    return _update(list);
  }

  @override
  deleteMusic(id, musics) async {
    final list = await _loadData();
    final index = list.indexWhere((e) => e.id == id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    final current = list[index];
    List<String> mids = musics.map((e) => e.id).toList();
    current.musicList.removeWhere((m) => mids.contains(m.id));

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: current.name,
      cover: current.cover,
      desc: current.desc,
      author: current.author,
      musicList: current.musicList,
    );

    return _update(list);
  }
}

Future<void> updateLocalMusicOrderData(List<MusicOrderItem> list) async {
  final localStorage = await SharedPreferences.getInstance();
  final jsonStr = json.encode(list);
  await localStorage.setString(LocalOriginConst.cacheKey, jsonStr);
}
