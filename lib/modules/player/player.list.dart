import 'package:flutter/material.dart';
import 'package:flutter_app/components/sheet/bottom_sheet.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:flutter_app/utils/clear_html_tags.dart';
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
                          return ListTile(
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(item.origin.name),
                                const SizedBox(width: 10),
                                Text(seconds2duration(item.duration)),
                              ],
                            ),
                            trailing: InkWell(
                              borderRadius: BorderRadius.circular(4.0),
                              child: const Icon(Icons.more_vert),
                              onTap: () {
                                showItemSheet(context, item);
                              },
                            ),
                            onTap: () {
                              Provider.of<PlayerModel>(context, listen: false)
                                  .play(item);
                            },
                            onLongPress: () {
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
          Provider.of<PlayerModel>(context, listen: false).play(data);
          Navigator.of(context).pop();
        }),
    SheetItem(
        title: const Text('在播放列表中移除'),
        onPressed: () {
          Provider.of<PlayerModel>(context, listen: false)
              .removePlayerList([data]);
          Navigator.of(context).pop();
        }),
    SheetItem(
      title: const Text('下载'),
      onPressed: () {},
    ),
  ]);
}
