import 'dart:convert';
import 'dart:io';

import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/database/database.dart';
import 'package:bbmusic/modules/data_sync/data_sync.dart';
import 'package:bbmusic/modules/download/model.dart';
import 'package:bbmusic/modules/open_music_order/utils.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/modules/search/search.dart';
import 'package:bbmusic/modules/setting/music_order_origin/mode.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/utils/logs.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManage {
  final db = AppDatabase();
  Future<Map<String, dynamic>> getData(BuildContext context) async {
    final player = Provider.of<PlayerModel>(context, listen: false);
    final orderOrigin =
        Provider.of<MusicOrderOriginSettingModel>(context, listen: false);
    var data = <String, dynamic>{};
    // 播放列表
    data[CacheKey.playerList] = player.playerList;
    // 搜索历史
    data[CacheKey.searchHistory] = await getSearchHistoryData();
    // 广场源
    data[CacheKey.openMusicOrderUrls] = await getMusicOrderUrl();
    // 云端歌单源
    data[CacheKey.cloudMusicOrderSetting] = orderOrigin.list
        .where((t) => t.name != LocalOriginConst.name)
        .map((l) => l.toJson())
        .toList();
    // 本地歌单
    if (orderOrigin.userMusicOrderList.isNotEmpty) {
      data[CacheKey.localMusicOrderList] = orderOrigin.userMusicOrderList
          .firstWhere((t) => t.id == LocalOriginConst.name)
          .list;
    } else {
      data[CacheKey.localMusicOrderList] = [];
    }
    return data;
  }

  Future<Map<String, dynamic>> getDataForDB() async {
    var data = <String, List<dynamic>>{};
    // 播放列表
    final playerList = await db.managers.playerListEntity.get();
    data[CacheKey.playerList] = playerList;
    // 搜索历史
    final searchHistory = await db.managers.searchHistoryEntity.get();
    data[CacheKey.searchHistory] = searchHistory.map((m) => m.name).toList();
    // 广场源
    final openMusicOrderUrls = await db.managers.openMusicOrderUrlEntity.get();
    data[CacheKey.openMusicOrderUrls] =
        openMusicOrderUrls.map((m) => m.url).toList();
    // 云端歌单
    final cloudMusicOrderList = await db.managers.cloudMusicOrderEntity.get();
    data[CacheKey.cloudMusicOrderSetting] = cloudMusicOrderList.map((o) {
      return {
        'id': o.id,
        'name': o.origin,
        'sub_name': o.subName,
        'config': jsonDecode(o.config ?? '{}'),
      };
    }).toList();

    // 本地歌单
    final localMusicOrderList = await db.managers.localMusicOrderEntity.get();
    final localMusicList = await db.managers.localMusicListEntity.get();
    data[CacheKey.localMusicOrderList] = localMusicOrderList.map((o) {
      return {
        'id': o.id,
        'name': o.name,
        'desc': o.desc,
        'cover': o.cover,
        'author': o.author,
        'musicList': localMusicList.where((m) => m.orderId == o.id).map(
          (m) {
            return {
              'id': m.musicId,
              "orderId": m.orderId,
              "dbId": m.id,
              'name': m.name,
              'cover': m.cover,
              'author': m.author,
              'duration': m.duration,
              'origin': m.origin,
            };
          },
        ).toList(),
      };
    }).toList();

    return data;
  }

  export(BuildContext context) async {
    // map 转 json
    final data = await getDataForDB();
    String jsonStr = jsonEncode(data);

    // 权限判断
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        var per = await Permission.manageExternalStorage.request();
        if (!per.isGranted) {
          throw '未授权';
        }
      }
    }
    // 写入文件
    String now =
        (DateTime.timestamp().millisecondsSinceEpoch ~/ 1000).toString();

    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: '导出配置',
        fileName: 'export_$now.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (outputFile == null) {
        return;
      }

      File file = File(outputFile);
      await file.writeAsString(jsonStr);
      BotToast.showText(text: '已导出到文件 $outputFile');
    } else {
      final downloadDir = await getDownloadDir();
      String filePath = path.join(downloadDir!.path, "export_$now.json");
      File file = File(filePath);
      await file.writeAsString(jsonStr);
      BotToast.showText(text: '已导出到文件 $filePath');
    }
  }

  // 导入 local
  importLocal(BuildContext context) async {
    final localStorage = await SharedPreferences.getInstance();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result != null) {
      // 获取文件内容
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      if (content.isEmpty) {
        return;
      }
      // json 转 map
      Map<String, dynamic> data = jsonDecode(content);
      final playerList = data[CacheKey.playerList];
      // 播放列表
      if (playerList is List && playerList.isNotEmpty) {
        await localStorage.setStringList(
          CacheKey.playerList,
          playerList.map((p) => jsonEncode(p)).toList(),
        );
      }
      // 搜索历史
      final searchHistory = data[CacheKey.searchHistory];
      if (searchHistory is List && searchHistory.isNotEmpty) {
        localStorage.setStringList(
          CacheKey.searchHistory,
          searchHistory.map((e) => e.toString()).toList(),
        );
      }
      // 广场源
      final openMusicOrderUrls = data[CacheKey.openMusicOrderUrls];
      if (openMusicOrderUrls is List && openMusicOrderUrls.isNotEmpty) {
        localStorage.setStringList(
          CacheKey.openMusicOrderUrls,
          openMusicOrderUrls.map((e) => e.toString()).toList(),
        );
      }
      // 云端歌单源
      final cloudList = data[CacheKey.cloudMusicOrderSetting];
      if (cloudList is List && cloudList.isNotEmpty) {
        localStorage.setString(
          CacheKey.cloudMusicOrderSetting,
          jsonEncode(cloudList),
        );
      }
      // 本地歌单
      final localList = data[CacheKey.localMusicOrderList];
      if (localList is List && localList.isNotEmpty) {
        localStorage.setString('umo_local', jsonEncode(localList));
      }

      BotToast.showText(text: "导入成功");
    }
  }

  // 导入
  import(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result != null) {
      // 获取文件内容
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      if (content.isEmpty) {
        return;
      }
      // json 转 map
      Map<String, dynamic> data = jsonDecode(content);
      // 播放列表
      final playerList = data[CacheKey.playerList] as List<dynamic>;
      // 搜索历史
      final searchHistory = data[CacheKey.searchHistory] as List<dynamic>;
      // 歌单广场地址
      final openMusicOrderUrls =
          data[CacheKey.openMusicOrderUrls] as List<dynamic>;
      // 云端歌单列表
      final cloudMusicOrderList =
          data[CacheKey.cloudMusicOrderSetting] as List<dynamic>;
      // 本地歌单列表
      final localMusicOrderList =
          data[CacheKey.localMusicOrderList] as List<dynamic>;

      try {
        await dataSyncDB(
          playerList: playerList.map((p) => MusicItem.fromJson(p)).toList(),
          searchHistory: searchHistory.map((e) => e.toString()).toList(),
          openMusicOrderUrls:
              openMusicOrderUrls.map((e) => e.toString()).toList(),
          cloudMusicOrder: cloudMusicOrderList
              .map((p) => OriginSettingItem.fromJson(p))
              .toList(),
          localMusicOrder: localMusicOrderList
              .map((p) => MusicOrderItem.fromJson(p))
              .toList(),
        );
        if (context.mounted) {
          final player = Provider.of<PlayerModel>(context, listen: false);
          await player.reloadPlayerList();
        }

        BotToast.showText(text: "导入成功");
      } catch (e) {
        BotToast.showText(text: "导入失败");
        logs.e('导入失败', error: e);
      }
    }
  }
}
