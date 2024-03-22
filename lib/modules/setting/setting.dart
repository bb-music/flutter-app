import 'package:flutter/material.dart';
import 'package:flutter_app/modules/user_music_order/user_music_order.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        children: [
          ...userMusicOrderOrigin.map((e) {
            return e.configWidget ?? const SizedBox();
          }),
        ],
      ),
    );
  }
}
