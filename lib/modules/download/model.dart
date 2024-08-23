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
import 'package:saver_gallery/saver_gallery.dart';

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
      final name = '${item.name}.mp4';
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
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    var per = await Permission.photos.request();
    if (!per.isGranted) {
      throw '未授权';
    }
  }
  // 文件保存路径
  String savePath = "";

  // 查询缓存文件
  final key = music2cacheKey(music);
  final cacheFile = await audioCacheManage.getFileFromCache(key);
  if (cacheFile?.file != null) {
    savePath = cacheFile!.file.path;
  } else {
    // 没有缓存文件，从网络下载
    var appDocDir = await getTemporaryDirectory();
    savePath = path.join('${appDocDir.path}/$name');
    final m = await service.getMusicUrl(music.id);
    await dio.download(
      m.url,
      savePath,
      options: Options(headers: m.headers),
    );
  }

  // 保存到相册
  await SaverGallery.saveFile(
    file: savePath,
    androidExistNotSave: true,
    name: name,
    androidRelativePath: "Movies",
  );
  //根据文件路径删除临时文件
  if (cacheFile?.file == null) {
    await File(savePath).delete();
  }
  return "";
}
