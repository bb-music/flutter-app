import 'package:bot_toast/bot_toast.dart' show BotToastInit, BotToast;
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/home/home.dart';
import 'package:flutter_app/modules/player/player.model.dart';
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
      ],
      child: MaterialApp(
        title: '哔哔音乐',
        theme: theme,
        home: const HomeView(),
        builder: (context, child) {
          // 设置 toast 默认值
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
