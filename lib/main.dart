import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:flutter_app/modules/search/search.dart';
import 'package:provider/provider.dart';

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
        home: const SearchView(),
      ),
    ),
  );
}
