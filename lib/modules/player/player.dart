import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.card.dart';
import 'package:flutter_app/modules/player/player.const.dart';
import 'package:flutter_app/modules/player/player.list.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
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
          child: GestureDetector(
            onTap: () {
              showPlayerCard(context);
            },
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
        if (player.playerStatus == PlayerStatus.play) {
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
            player.play(null);
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
          onPressed: () {},
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
          onPressed: () {},
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

  const PlayerListButton({this.size = 30.0});

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
            player.togglePlayerMode(null);
            Fluttertoast.showToast(
              msg: "This is Center Short Toast",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
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
Future<T?> showPlayerList<T>(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: false);
  return navigator.push(ModalBottomSheetRoute<T>(
    isScrollControlled: true,
    builder: (context) {
      return PlayerList();
    },
  ));
}

/// 显示播放卡片
Future<T?> showPlayerCard<T>(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: false);
  return navigator.push(ModalBottomSheetRoute<T>(
    isScrollControlled: false,
    builder: (context) {
      return PlayerCard();
    },
  ));
}
