import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/home/home.dart';
import 'package:flutter_app/modules/music_order/model.dart';
import 'package:flutter_app/modules/player/model.dart';
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

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayerModel()),
        ChangeNotifierProvider(create: (context) => UserMusicOrderModel()),
      ],
      child: MaterialApp(
        title: '哔哔音乐',
        theme: theme,
        home: const HomeView(),
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: (context, child) {
          // 初始化播放器
          Provider.of<PlayerModel>(context, listen: false).init();
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
