import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/player/card.dart';
import 'package:bbmusic/modules/player/list.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        showPlayerCard(context);
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.only(left: 15, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).secondaryHeaderColor,
          border: Border.all(color: primaryColor, width: .5),
        ),
        child: const Flex(
          direction: Axis.horizontal,
          children: [
            PlayInfo(),
            Row(children: [
              PlayButton(),
              NextButton(),
              PlayerListButton(),
            ]),
          ],
        ),
      ),
    );
  }
}

/// 音乐信息
class PlayInfo extends StatelessWidget {
  const PlayInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        String name = player.current?.name ?? '暂无歌曲';

        return Expanded(
          flex: 1,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

/// 播放/暂停按钮
class PlayButton extends StatelessWidget {
  final double? size;

  const PlayButton({super.key, this.size = 56.0});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        if (player.isPlaying) {
          return IconButton(
            color: primaryColor,
            iconSize: size,
            icon: const Icon(
              Icons.pause_circle_filled,
            ),
            onPressed: () {
              player.pause();
            },
          );
        }
        return IconButton(
          color: primaryColor,
          iconSize: size,
          icon: const Icon(
            Icons.play_circle_filled,
          ),
          onPressed: () {
            player.play();
          },
        );
      },
    );
  }
}

/// 上一首
class PrevButton extends StatelessWidget {
  final double? size;

  const PrevButton({super.key, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return IconButton(
          color: primaryColor,
          onPressed: () {
            player.prev();
          },
          iconSize: size,
          icon: const Icon(
            Icons.skip_previous,
          ),
        );
      },
    );
  }
}

/// 下一首
class NextButton extends StatelessWidget {
  final double? size;

  const NextButton({super.key, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return IconButton(
          color: primaryColor,
          iconSize: size,
          onPressed: () {
            player.next();
          },
          icon: const Icon(
            Icons.skip_next,
          ),
        );
      },
    );
  }
}

/// 播放列表
class PlayerListButton extends StatelessWidget {
  final double? size;

  const PlayerListButton({super.key, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return IconButton(
          color: primaryColor,
          iconSize: size,
          onPressed: () {
            showPlayerList(context);
          },
          icon: const Icon(
            Icons.queue_music,
          ),
        );
      },
    );
  }
}

/// 播放模式
class ModeButton extends StatelessWidget {
  final double? size;

  const ModeButton({super.key, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return IconButton(
          color: primaryColor,
          iconSize: size,
          onPressed: () {
            player.togglePlayerMode();
            BotToast.showText(text: "${player.playerMode.name}模式");
            // Fluttertoast.showToast(
            //   msg: "${player.playerMode.name}模式",
            //   // toastLength: Toast.LENGTH_SHORT,
            //   // timeInSecForIosWeb: 1,
            //   // backgroundColor: Colors.red,
            //   // textColor: Colors.white,
            //   fontSize: 16.0,
            // );
          },
          icon: Icon(
            player.playerMode.icon,
          ),
        );
      },
    );
  }
}

/// 显示播放列表
Future showPlayerList(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: false);
  return navigator.push(ModalBottomSheetRoute(
    isScrollControlled: true,
    builder: (context) {
      return const PlayerList();
    },
  ));
}

/// 显示播放卡片
Future<void>? showPlayerCard(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: false);
  final player = Provider.of<PlayerModel>(context, listen: false);
  if (player.current == null) return null;
  return navigator.push(ModalBottomSheetRoute(
    isScrollControlled: true,
    builder: (context) {
      return const PlayerCard();
    },
  ));
}
