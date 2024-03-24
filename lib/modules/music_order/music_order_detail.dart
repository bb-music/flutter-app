import 'package:flutter/material.dart';
import 'package:flutter_app/components/sheet/bottom_sheet.dart';
import 'package:flutter_app/components/text_tags/tags.dart';
import 'package:flutter_app/modules/player/player.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

class MusicOrderDetail extends StatelessWidget {
  final MusicOrderItem data;

  const MusicOrderDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            tooltip: '更多操作',
            onPressed: () {
              final player = Provider.of<PlayerModel>(context, listen: false);
              openBottomSheet(context, [
                SheetItem(
                  title: const Text('播放全部'),
                  onPressed: () {
                    player.clearPlayerList();
                    player.addPlayerList(data.musicList);
                    player.play(data.musicList[0]);
                    Navigator.of(context).pop();
                  },
                ),
                SheetItem(
                  title: const Text('追加到播放列表'),
                  onPressed: () {
                    player.addPlayerList(data.musicList);
                    Navigator.of(context).pop();
                  },
                ),
                SheetItem(
                  title: const Text('加入歌单'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
            },
          )
        ],
      ),
      floatingActionButton: const PlayerView(),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: data.musicList.length,
          itemBuilder: (context, index) {
            if (data.musicList.isEmpty) return null;
            final item = data.musicList[index];
            final List<String> tags = [
              item.origin.name,
              item.duration.toString()
            ];
            return ListTile(
              title: Text(item.name),
              subtitle: TextTags(tags: tags),
              onTap: () {
                Provider.of<PlayerModel>(context, listen: false).play(item);
              },
            );
          }),
    );
  }
}
