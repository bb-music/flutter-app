import 'package:bbmusic/database/database.dart';
import 'package:bbmusic/database/uuid.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
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

  final db = AppDatabase();

  Future<List<MusicOrderItem>> _loadData() async {
    final orderList = await db.managers.localMusicOrderEntity.get();
    final musicList = await db.managers.localMusicListEntity.get();

    final List<MusicOrderItem> list = [];
    for (var item in orderList) {
      final mList = musicList.where((m) => m.orderId == item.id).map((m) {
        return MusicItem(
          id: m.id.toString(),
          name: m.name,
          cover: m.cover ?? '',
          author: m.author ?? '',
          duration: m.duration,
          origin: OriginType.getByValue(m.origin),
        );
      }).toList();
      list.add(MusicOrderItem(
        id: item.id,
        name: item.name,
        desc: item.desc ?? '',
        author: item.author ?? '',
        musicList: mList,
      ));
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
    final info = await db.managers.localMusicOrderEntity
        .filter((f) => f.name.equals(data.name.trim()))
        .get();
    if (info.isNotEmpty) {
      throw Exception('歌单已存在');
    }
    final musicOrder =
        await db.managers.localMusicOrderEntity.createReturning((o) {
      return o(
        id: generateUUID(),
        name: data.name,
        cover: Value(data.cover),
        desc: Value(data.desc),
        author: Value(data.author),
      );
    });
    if (data.musicList.isNotEmpty) {
      for (var m in data.musicList) {
        await db.managers.localMusicListEntity.create((o) {
          return o(
            id: generateUUID(),
            orderId: musicOrder.id,
            musicId: m.id,
            name: m.name,
            cover: Value(m.cover),
            author: Value(m.author),
            duration: m.duration,
            origin: m.origin.value,
          );
        });
      }
    }
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
    await getList();
  }

  @override
  Future<void> update(data) async {
    final current =
        db.managers.localMusicOrderEntity.filter((f) => f.id.equals(data.id));
    final info = await current.get();
    if (info.isEmpty) {
      throw Exception('歌单不存在');
    }

    await current.update((o) {
      return o(
        name: Value(data.name),
        desc: Value(data.desc),
        cover: Value(data.cover),
        author: Value(data.author),
        updatedAt: Value(DateTime.now()),
      );
    });
  }

  @override
  Future<void> delete(data) async {
    await db.managers.localMusicOrderEntity
        .filter((f) => f.id.equals(data.id))
        .delete();
    await db.managers.localMusicListEntity
        .filter((f) => f.orderId.equals(data.id))
        .delete();
  }

  @override
  getDetail(id) async {
    final order = await db.managers.localMusicOrderEntity
        .filter((f) => f.id.equals(id))
        .getSingleOrNull();
    if (order == null) {
      throw Exception('歌单不存在');
    }
    final list = await db.managers.localMusicListEntity
        .filter((f) => f.orderId.equals(id))
        .get();
    return MusicOrderItem(
      id: order.id,
      name: order.name,
      desc: order.desc ?? '',
      author: order.author ?? '',
      musicList: list
          .map((l) => MusicItem(
                id: l.musicId,
                name: l.name,
                cover: l.cover ?? '',
                author: l.author ?? '',
                duration: l.duration,
                origin: OriginType.getByValue(l.origin),
              ))
          .toList(),
    );
  }

  @override
  appendMusic(orderID, musics) async {
    final current = await db.managers.localMusicOrderEntity
        .filter((f) => f.id.equals(orderID))
        .getSingleOrNull();
    if (current == null) {
      throw Exception('歌单不存在');
    }
    for (var m in musics) {
      await db.managers.localMusicListEntity.create((o) {
        return o(
          id: generateUUID(),
          orderId: orderID,
          musicId: m.id,
          name: m.name,
          cover: Value(m.cover),
          author: Value(m.author),
          duration: m.duration,
          origin: m.origin.value,
        );
      });
    }
  }

  @override
  updateMusic(orderID, musics) async {
    for (var m in musics) {
      await db.managers.localMusicListEntity
          .filter((f) => f.orderId.equals(orderID) & f.musicId.equals(m.id))
          .update((o) {
        return o(
          name: Value(m.name),
          cover: Value(m.cover),
          duration: Value(m.duration),
          author: Value(m.author),
          origin: Value(m.origin.value),
        );
      });
    }
  }

  @override
  deleteMusic(id, musics) async {
    await db.managers.localMusicListEntity
        .filter((f) =>
            f.orderId.equals(id) &
            f.musicId.isIn(musics.map((e) => e.id).toList()))
        .delete();
  }
}
