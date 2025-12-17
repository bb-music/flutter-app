import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// 检查更新版本
updateAppVersion() async {
  final dio = Dio();
  try {
    final resp = await dio.get(
      "https://api.github.com/repos/bb-music/flutter-app/releases/latest",
      options: Options(headers: {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28'
      }),
    );
    String latestVersion = resp.data['tag_name'];
    latestVersion = latestVersion.replaceFirst('v', '');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    // 版本号对比
    if (isUpdateVersion(latestVersion, currentVersion)) {
      BotToast.showCustomLoading(
        toastBuilder: (cancelFunc) {
          return AlertDialog(
            title: const Text('发现新版本，是否更新？'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            actions: [
              TextButton(
                onPressed: () {
                  cancelFunc();
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  cancelFunc();
                  // 打开网址
                  launchUrl(
                    Uri.parse(
                      "https://github.com/bb-music/flutter-app/releases/latest",
                    ),
                  );
                },
                child: const Text("确定"),
              )
            ],
          );
        },
      );
    }
  } catch (e) {
    if (e is DioException) {
      print(e.message);
    }
  }
}

bool isUpdateVersion(String newVersion, String old) {
  if (newVersion.isEmpty || old.isEmpty) {
    return false;
  }
  int newVersionInt, oldVersion;
  var newList = newVersion.split('.');
  var oldList = old.split('.');
  if (newList.isEmpty || oldList.isEmpty) {
    return false;
  }
  for (int i = 0; i < newList.length; i++) {
    newVersionInt = int.parse(newList[i]);
    oldVersion = int.parse(oldList[i]);
    if (newVersionInt > oldVersion) {
      return true;
    } else if (newVersionInt < oldVersion) {
      return false;
    }
  }
  return false;
}
