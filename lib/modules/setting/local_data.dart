import 'dart:convert';
import 'dart:io';

import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/modules/download/model.dart';
import 'package:bbmusic/modules/open_music_order/utils.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/modules/search/search.dart';
import 'package:bbmusic/modules/setting/music_order_origin/mode.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:bbmusic/modules/user_music_order/local/local.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class LocalDataManage {
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
    data[CacheKey.localMusicOrderList] = await orderOrigin.userMusicOrderList
        .firstWhere((t) => t.id == LocalOriginConst.name)
        .list;
    return data;
  }

  export(BuildContext context) async {
    // map 转 json
    final data = await getData(context);
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
    final downloadDir = await getDownloadDir();
    String filePath = path.join(downloadDir!.path, "export_$now.json");
    File file = File(filePath);
    file.writeAsString(jsonStr);
    BotToast.showText(text: '已导出到文件 $filePath');
  }

  import(BuildContext context) async {
    final player = Provider.of<PlayerModel>(context, listen: false);
    final orderOrigin =
        Provider.of<MusicOrderOriginSettingModel>(context, listen: false);

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
        player.clearPlayerList();
        final List<MusicItem> list = playerList
            .map(
              (item) => MusicItem.fromJson(item),
            )
            .toList();
        player.addPlayerList(list);
      }
      // 搜索历史
      final searchHistory = data[CacheKey.searchHistory];
      if (searchHistory is List && searchHistory.isNotEmpty) {
        await updateSearchHistoryData(
          searchHistory.map((e) => e.toString()).toList(),
        );
      }
      // 广场源
      final openMusicOrderUrls = data[CacheKey.openMusicOrderUrls];
      if (openMusicOrderUrls is List && openMusicOrderUrls.isNotEmpty) {
        setMusicOrderUrl(
          openMusicOrderUrls.map((e) => e.toString()).toList(),
        );
      }
      // 云端歌单源
      final cloudList = data[CacheKey.cloudMusicOrderSetting];
      if (cloudList is List && cloudList.isNotEmpty) {
        for (var item in cloudList) {
          orderOrigin.add(
            item['name'],
            item['sub_name'],
            item['config'],
          );
        }
      }
      // 本地歌单
      final localList = data[CacheKey.localMusicOrderList];
      if (localList is List && localList.isNotEmpty) {
        for (var item in orderOrigin.userMusicOrderList) {
          if (item.service.name == LocalOriginConst.name) {
            await updateLocalMusicOrderData(
              localList.map((item) => MusicOrderItem.fromJson(item)).toList(),
            );
            orderOrigin.loadSignal(LocalOriginConst.name);
          }
        }
      }
      BotToast.showText(text: "导入成功");
    }
  }
}
