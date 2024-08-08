import 'package:flutter/material.dart';
import 'package:bbmusic/modules/user_music_order/user_music_order.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        children: [
          ...userMusicOrderOrigin.map((e) {
            final configWidget = e.configBuild();
            if (configWidget == null) return const SizedBox();
            return ListTile(
              title: Text('${e.cname} 歌单源设置'),
              leading: Icon(e.icon),
              minTileHeight: 60,
              onTap: () {
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) {
                      return configWidget;
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
