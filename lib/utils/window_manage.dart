import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

initWindowManage() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(460, 900),
    minimumSize: Size(400, 700),
    // center: true,
    title: "哔哔音乐",
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.setMaximizable(false);
  if (Platform.isWindows) {
    windowManager.setIcon("assets/ic_launch.png");
  }
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
