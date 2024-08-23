import 'package:bbmusic/components/music_list_tile/music_list_tile.dart';
import 'package:bbmusic/modules/download/model.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/components/sheet/bottom_sheet.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 45;
    double topHeight = 56;
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return SizedBox(
          height: height,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Container(
                height: topHeight,
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "播放列表",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${player.playerList.length}首歌曲",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).disabledColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Tooltip(
                      message: "清空列表",
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          Provider.of<PlayerModel>(context, listen: false)
                              .clearPlayerList();
                        },
                      ),
                    )
                  ],
                ),
              ),
              player.playerList.isEmpty
                  ? Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: const Text("播放列表中暂时没有歌曲"),
                    )
                  : SizedBox(
                      height: height - topHeight,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: player.playerList.length,
                        itemBuilder: (context, index) {
                          final item = player.playerList.toList()[index];
                          return MusicListTile(
                            item,
                            onMore: () {
                              showItemSheet(context, item);
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

void showItemSheet(BuildContext context, MusicItem data) {
  final playerModel = Provider.of<PlayerModel>(context, listen: false);
  final downloadModel = Provider.of<DownloadModel>(context, listen: false);
  openBottomSheet(context, [
    SheetItem(
      title: Text(
        data.name,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
    SheetItem(
        title: const Text('播放'),
        onPressed: () {
          playerModel.play(music: data);
        }),
    SheetItem(
        title: const Text('在播放列表中移除'),
        onPressed: () {
          playerModel.removePlayerList([data]);
        }),
    SheetItem(
      title: const Text('下载'),
      onPressed: () {
        downloadModel.download([data]);
      },
    ),
  ]);
}
