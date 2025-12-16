import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bbmusic/modules/download/model.dart';
import 'package:bbmusic/modules/open_music_order/model.dart';
import 'package:bbmusic/modules/setting/music_order_origin/mode.dart';
import 'package:bbmusic/utils/update_version.dart';
import 'package:bbmusic/utils/window_manage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/home/home.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/modules/player/service.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:provider/provider.dart';

// toast 初始化
final botToastBuilder = BotToastInit();
// 主题
const primaryColor = Color.fromRGBO(103, 58, 183, 1);

ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    primary: primaryColor,
    brightness: Brightness.light,
  ),
  primaryColor: primaryColor,
);

final _playerHandler = AudioPlayerHandler();

void main() async {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await initWindowManage();
  }
  WidgetsFlutterBinding.ensureInitialized();
  JustAudioMediaKit.ensureInitialized(
    iOS: false,
    android: false,
    windows: true,
    linux: true,
    macOS: false,
  );
  final playerService = await AudioService.init(
    builder: () => _playerHandler,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.bbmusic.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayerModel()),
        ChangeNotifierProvider(create: (context) => OpenMusicOrderModel()),
        ChangeNotifierProvider(
            create: (context) => MusicOrderOriginSettingModel()),
        ChangeNotifierProvider(create: (context) => DownloadModel()),
      ],
      child: MaterialApp(
        title: '哔哔音乐',
        theme: theme,
        home: const HomeView(),
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: (context, child) {
          // 初始化播放器
          Provider.of<PlayerModel>(context, listen: false).init(
            playerHandler: _playerHandler,
            playerService: playerService,
          );
          // 消息提示框的默认配置
          BotToast.defaultOption.text.duration = const Duration(seconds: 10);
          BotToast.defaultOption.text.textStyle = TextStyle(
            fontSize: 12,
            color: Theme.of(context).cardColor,
          );
          child = botToastBuilder(context, child);
          Timer(Duration(seconds: 1), () {
            updateAppVersion();
          });
          return child;
        },
      ),
    ),
  );
}
