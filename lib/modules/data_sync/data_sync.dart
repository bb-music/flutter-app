import 'dart:convert';

import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/database/database.dart';
import 'package:bbmusic/database/uuid.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:bbmusic/utils/logs.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

// 将之前存储在本地缓存中的数据同步到数据库中
Future<void> syncLocalDataToDatabase() async {
  // try {
  final localStorage = await SharedPreferences.getInstance();
  // 数据库地址
  // final dbPath = await getApplicationSupportDirectory();
  // 是否已经同步过
  final isSync = localStorage.getBool("isSyncDataBase") ?? false;
  if (isSync) {
    return;
  }
  final db = AppDatabase();
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
      localStorage.getString(LocalOriginConst.cacheKey) ?? "[]";
  final localMusicOrder = jsonDecode(localMusicOrderStr) as List<dynamic>;

  // 同步播放列表到数据库
  if (playerList.isNotEmpty) {
    db.managers.playerListEntity.delete();
    for (var p in playerList) {
      final data = jsonDecode(p);
      await db.managers.playerListEntity.create(
        (o) {
          return o(
            id: data['id'],
            cover: Value(data['cover'] ?? ''),
            name: data['name'],
            duration: data['duration'],
            author: Value(data['author'] ?? ''),
            origin: data['origin'],
          );
        },
        mode: InsertMode.replace,
      );
    }
  }

  // 同步搜索历史到数据库
  if (searchHistory.isNotEmpty) {
    db.managers.searchHistoryEntity.delete();
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
    db.managers.openMusicOrderUrlEntity.delete();
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
    db.managers.cloudMusicOrderEntity.delete();
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
    db.managers.localMusicOrderEntity.delete();
    db.managers.localMusicListEntity.delete();
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
                origin: m['origin'],
              );
            },
            mode: InsertMode.replace,
          );
        }
      }
    }
  }

  localStorage.setBool("isSyncDataBase", true);
  logs.i('同步数据成功');
  // } catch (e) {
  //   logs.e("同步数据失败", error: e);
  // }
}
