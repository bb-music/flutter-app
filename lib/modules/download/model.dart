import 'dart:io';

import 'package:bbmusic/modules/download/types.dart';
import 'package:bbmusic/modules/player/source.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final dio = Dio();

class DownloadModel extends ChangeNotifier {
  // 下载列表
  final List<DownloadItem> list = [];
  // 并行数量
  int parallelCount = 3;

  // 添加下载任务
  void addDownloadTask(DownloadItem item) {
    list.add(item);
    notifyListeners();
  }

  // 下载
  void download(List<MusicItem> musics) async {
    for (var item in musics) {
      final name = '${item.name.replaceAll("/", "_")}.mp3';
      String resultPath = "";
      try {
        if (Platform.isAndroid) {
          resultPath = await _downloadForAndroid(item, name);
        } else {
          resultPath = await _downloadForDesktop(item, name);
        }
        BotToast.showText(text: '下载完成: $resultPath');
      } catch (e) {
        BotToast.showText(text: '下载失败');
        print('下载失败, $e');
      }
    }
  }
}

Future<Directory?> getDownloadDir() async {
  if (Platform.isAndroid) {
    return Directory('/storage/emulated/0/Download/哔哔音乐');
  }
  return await getDownloadsDirectory();
}

Future<String> _downloadForDesktop(
  MusicItem music,
  String name,
) async {
  final dir = await getDownloadDir();
  final addr = path.join('${dir!.path}/$name');

  // 查询缓存文件
  final key = music2cacheKey(music);
  final cacheFile = await audioCacheManage.getFileFromCache(key);
  if (cacheFile?.file != null) {
    final file = cacheFile!.file;
    await file.copy(addr);
    return addr;
  }
  // 从网络下载
  final m = await service.getMusicUrl(music.id);
  await dio.download(
    m.url,
    addr,
    options: Options(headers: m.headers),
  );
  return addr;
}

Future<String> _downloadForAndroid(
  MusicItem music,
  String name,
) async {
  // 判断是否授权
  var status = await Permission.manageExternalStorage.status;
  if (!status.isGranted) {
    var per = await Permission.manageExternalStorage.request();
    if (!per.isGranted) {
      throw '未授权';
    }
  }

  // 获取目录下的文件列表
  final dir = await getDownloadDir();
  // 判断目录是否存在
  if (!dir!.existsSync()) {
    dir.createSync(recursive: true);
  }

  // 查询缓存文件
  final key = music2cacheKey(music);
  final cacheFile = await audioCacheManage.getFileFromCache(key);
  // 保存路径
  String savePath = path.join(dir!.path, name);
  if (cacheFile?.file != null) {
    // 文件保存
    cacheFile!.file.copy(savePath);
  } else {
    // 没有缓存文件，从网络下载
    final m = await service.getMusicUrl(music.id);
    await dio.download(
      m.url,
      savePath,
      options: Options(headers: m.headers),
    );
  }

  return savePath;
}
