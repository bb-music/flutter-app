import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.const.dart';
import 'package:flutter_app/modules/player/player.list.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        Color primaryColor = Theme.of(context).primaryColor;
        String name = player.current?.name ?? '暂无歌曲';

        return Container(
          height: 70,
          width: MediaQuery.of(context).size.width - 30,
          padding: const EdgeInsets.only(left: 15, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).secondaryHeaderColor,
            border: Border.all(color: primaryColor, width: .5),
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Text(duration)
                  ],
                ),
              ),
              Row(children: [
                PlayButton(),
                NextButton(),
                IconButton(
                  color: primaryColor,
                  onPressed: () {
                    showPlayerList(context);
                  },
                  icon: const Icon(
                    Icons.queue_music,
                    size: 30,
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        if (player.playerStatus == PlayerStatus.play) {
          return IconButton(
            color: primaryColor,
            icon: const Icon(
              Icons.pause_circle_filled,
              size: 56,
            ),
            onPressed: () {
              player.pause();
            },
          );
        }
        return IconButton(
          color: primaryColor,
          icon: const Icon(
            Icons.play_circle_filled,
            size: 56,
          ),
          onPressed: () {
            player.play(null);
          },
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return IconButton(
          color: primaryColor,
          onPressed: () {},
          icon: const Icon(
            Icons.skip_next,
            size: 30,
          ),
        );
      },
    );
  }
}

Future<T?> showPlayerList<T>(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: false);
  return navigator.push(ModalBottomSheetRoute<T>(
    isScrollControlled: true,
    builder: (context) {
      return PlayerList();
    },
  ));
}
