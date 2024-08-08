import 'dart:io';

import 'package:bbmusic/modules/download/types.dart';
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
      final m = await service.getMusicUrl(musics[0].id);
      final name = '${item.name}.mp4';
      try {
        if (Platform.isAndroid) {
          await downloadForAndroid(m.url, name, m.headers);
        } else {
          await downloadForDesktop(m.url, name, m.headers);
        }
        BotToast.showText(text: '下载完成');
      } catch (e) {
        BotToast.showText(text: '下载失败');
        print('下载失败, $e');
      }
    }
    // notifyListeners();
  }
}

Future<Directory?> getDownloadDir() async {
  return await getDownloadsDirectory();
}

downloadForDesktop(
  String url,
  String name,
  Map<String, String>? headers,
) async {
  final dir = await getDownloadDir();
  final addr = path.join('${dir!.path}/$name');

  await dio.download(
    url,
    addr,
    options: Options(headers: headers),
  );
  print("下载位置: $addr");
}

downloadForAndroid(
  String url,
  String name,
  Map<String, String>? headers,
) async {
  var status = await Permission.phone.status;
  print("授权状态: $status");

  if (!status.isGranted) {
    print("未授权");
    var per = await Permission.photos.request();
    print("授权状态: $per");
    if (per.isGranted) {
      print("授权成功");
    } else {
      print("授权失败");
      return;
    }
  }
  var appDocDir = await getTemporaryDirectory();

  String savePath = path.join('${appDocDir.path}/$name');
  print("临时目录：$savePath");

  await dio.download(
    url,
    savePath,
    options: Options(headers: headers),
  );
  print("临时目录保存完成");

  try {
    final result = await SaverGallery.saveFile(
      file: savePath,
      androidExistNotSave: true,
      name: name,
      androidRelativePath: "Movies",
    );
    print(result);

    print("下载位置: $savePath");
  } catch (e) {
    print(e);
  }
}
