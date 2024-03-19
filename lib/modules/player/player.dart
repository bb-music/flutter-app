import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerModel>(
      builder: (context, player, child) => Row(
        children: [
          FilledButton(
            child: const Text('播放'),
            onPressed: () {
              player.play(null);
            },
          )
        ],
      ),
    );
  }
}
