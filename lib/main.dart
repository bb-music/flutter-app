import 'package:audio_service/audio_service.dart';
import 'package:bbmusic/modules/download/model.dart';
import 'package:bbmusic/modules/open_music_order/model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/home/home.dart';
import 'package:bbmusic/modules/music_order/model.dart';
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
  JustAudioMediaKit.ensureInitialized(
    iOS: false,
    windows: true,
    android: true,
    linux: true,
    macOS: true,
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
        ChangeNotifierProvider(create: (context) => UserMusicOrderModel()),
        ChangeNotifierProvider(create: (context) => OpenMusicOrderModel()),
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
          // 初始化歌单
          Provider.of<UserMusicOrderModel>(context, listen: false).init();

          BotToast.defaultOption.text.textStyle = TextStyle(
            fontSize: 12,
            color: Theme.of(context).cardColor,
          );
          child = botToastBuilder(context, child);
          return child;
        },
      ),
    ),
  );
}
