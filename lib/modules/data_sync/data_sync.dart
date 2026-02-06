import 'dart:convert';

import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/database/database.dart';
import 'package:bbmusic/database/uuid.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/utils/logs.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String localMusicOrderCacheKey = 'umo_local'; // 本地歌单列表缓存键

// 将之前存储在本地缓存中的数据同步到数据库中
Future<void> autoSyncLocalDataToDatabase() async {
  try {
    final localStorage = await SharedPreferences.getInstance();
    // 数据库地址
    // final dbPath = await getApplicationSupportDirectory();
    // 是否已经同步过
    final isSync = localStorage.getBool(CacheKey.isSyncDB) ?? false;
    if (isSync) {
      return;
    }
    // 播放列表
    final playerList = localStorage.getStringList(CacheKey.playerList) ?? [];
    // 搜索历史
    final searchHistory =
        localStorage.getStringList(CacheKey.searchHistory) ?? [];
    // 歌单广场地址
    final openMusicOrderUrls =
        localStorage.getStringList(CacheKey.openMusicOrderUrls) ?? [];
    // 云端歌单列表
    final cloudMusicOrderStr =
        localStorage.getString(CacheKey.cloudMusicOrderSetting) ?? "[]";
    final cloudMusicOrder = jsonDecode(cloudMusicOrderStr) as List<dynamic>;
    // 本地歌单列表
    final localMusicOrderStr =
        localStorage.getString(localMusicOrderCacheKey) ?? "[]";
    final localMusicOrder = jsonDecode(localMusicOrderStr) as List<dynamic>;

    await dataSyncDB(
      playerList:
          playerList.map((p) => jsonDecode(p) as Map<String, dynamic>).toList(),
      searchHistory: searchHistory,
      openMusicOrderUrls: openMusicOrderUrls,
      cloudMusicOrder:
          cloudMusicOrder.map((p) => p as Map<String, dynamic>).toList(),
      localMusicOrder:
          localMusicOrder.map((p) => p as Map<String, dynamic>).toList(),
      isReplace: true,
    );

    // 将本地缓存中的数据删除
    for (var key in [
      CacheKey.playerList,
      CacheKey.searchHistory,
      CacheKey.openMusicOrderUrls,
      CacheKey.cloudMusicOrderSetting,
      localMusicOrderCacheKey
    ]) {
      localStorage.remove(key);
    }
    localStorage.setBool(CacheKey.isSyncDB, true);
    logs.i('同步数据成功');
  } catch (e) {
    logs.e("同步数据失败", error: e);
  }
}

Future<void> dataSyncDB({
  // 播放列表
  required List<Map<String, dynamic>> playerList,
  // 搜索历史
  required List<String> searchHistory,
  // 歌单广场地址
  required List<String> openMusicOrderUrls,
  // 云端歌单列表
  required List<Map<String, dynamic>> cloudMusicOrder,
  // 本地歌单列表
  required List<Map<String, dynamic>> localMusicOrder,
  // 是否覆盖
  bool? isReplace = false,
}) async {
  final db = AppDatabase();

  // 同步播放列表到数据库
  if (playerList.isNotEmpty) {
    if (isReplace == true) {
      db.managers.playerListEntity.delete();
    }
    for (var data in playerList) {
      await db.managers.playerListEntity.create(
        (o) {
          return o(
            id: data['id'],
            cover: Value(data['cover'] ?? ''),
            name: data['name'],
            duration: data['duration'],
            author: Value(data['author'] ?? ''),
            origin: OriginType.getByValue(data['origin']).value,
          );
        },
        mode: InsertMode.replace,
      );
    }
  }

  // 同步搜索历史到数据库
  if (searchHistory.isNotEmpty) {
    if (isReplace == true) {
      db.managers.searchHistoryEntity.delete();
    }
    for (var p in searchHistory) {
      db.managers.searchHistoryEntity.create(
        (o) {
          return o(
            name: p,
          );
        },
        mode: InsertMode.replace,
      );
    }
  }

  // 同步歌单广场地址到数据库
  if (openMusicOrderUrls.isNotEmpty) {
    if (isReplace == true) {
      db.managers.openMusicOrderUrlEntity.delete();
    }
    for (var p in openMusicOrderUrls) {
      db.managers.openMusicOrderUrlEntity.create(
        (o) {
          return o(
            id: generateUUID(),
            url: p,
          );
        },
        mode: InsertMode.replace,
      );
    }
  }

  // 同步云端歌单列表到数据库
  if (cloudMusicOrder.isNotEmpty) {
    if (isReplace == true) {
      db.managers.cloudMusicOrderEntity.delete();
    }
    for (var p in cloudMusicOrder) {
      db.managers.cloudMusicOrderEntity.create(
        (o) {
          return o(
            id: generateUUID(),
            origin: p['name'],
            subName: p['sub_name'] ?? '',
            config: jsonEncode(p['config']),
          );
        },
        mode: InsertMode.replace,
      );
    }
  }

  // 同步本地歌单列表到数据库
  if (localMusicOrder.isNotEmpty) {
    if (isReplace == true) {
      db.managers.localMusicOrderEntity.delete();
      db.managers.localMusicListEntity.delete();
    }
    for (var data in localMusicOrder) {
      final info = await db.managers.localMusicOrderEntity.createReturning((o) {
        return o(
          id: generateUUID(),
          name: data['name'],
          desc: Value(data['desc'] ?? ''),
          cover: Value(data['cover'] ?? ''),
          author: Value(data['author'] ?? ''),
        );
      });
      final musicList = data['musicList'];

      // 关联歌曲与歌单
      if (musicList is List<dynamic>) {
        for (var m in musicList) {
          db.managers.localMusicListEntity.create(
            (o) {
              return o(
                id: generateUUID(),
                orderId: info.id,
                musicId: m['id'],
                name: m['name'],
                duration: m['duration'] ?? 0,
                cover: Value(m['cover'] ?? ''),
                author: Value(m['author'] ?? ''),
                origin: OriginType.getByValue(m['origin']).value,
              );
            },
            mode: InsertMode.replace,
          );
        }
      }
    }
  }
}
