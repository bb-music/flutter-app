import 'dart:io';

import 'package:bbmusic/modules/download/types.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
    print("downloadMusics");
    print(musics);
    final p4 = await getDownloadDir();
    print("下载目录 $p4");
    // notifyListeners();
  }
}

getDownloadDir() async {
  // 判断平台
  if (Platform.isAndroid) {
    return Directory("/storage/emulated/0/Download/");
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return await getDownloadsDirectory();
  }
}
