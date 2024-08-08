import 'package:bbmusic/modules/download/model.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/components/sheet/bottom_sheet.dart';
import 'package:bbmusic/components/text_tags/tags.dart';
import 'package:bbmusic/modules/music_order/list.dart';
import 'package:bbmusic/modules/music_order/model.dart';
import 'package:bbmusic/modules/player/player.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/utils/clear_html_tags.dart';
import 'package:provider/provider.dart';

class MusicOrderDetail extends StatefulWidget {
  final MusicOrderItem data;
  final UserMusicOrderOrigin? umoService;

  const MusicOrderDetail({super.key, this.umoService, required this.data});

  @override
  _MusicOrderDetailState createState() => _MusicOrderDetailState();
}

class _MusicOrderDetailState extends State<MusicOrderDetail> {
  late MusicOrderItem musicOrder;

  @override
  initState() {
    super.initState();
    musicOrder = widget.data;
  }

  _moreHandler(BuildContext context, MusicItem item) {
    openBottomSheet(context, [
      SheetItem(
        title: Text(
          item.name,
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
          Provider.of<PlayerModel>(context, listen: false).play(music: item);
        },
      ),
      SheetItem(
        title: const Text('添加到歌单'),
        onPressed: () {
          collectToMusicOrder(context, [item]);
        },
      ),
      SheetItem(
        title: const Text('编辑'),
        onPressed: () {},
        hidden: widget.umoService == null,
      ),
      SheetItem(
        title: const Text('从歌单中移除'),
        onPressed: () async {
          await widget.umoService!.deleteMusic(musicOrder.id, [item]);
          setState(() {
            musicOrder.musicList.remove(item);
          });

          if (context.mounted) {
            Provider.of<UserMusicOrderModel>(context, listen: false)
                .load(widget.umoService!.name);
          }
        },
        hidden: widget.umoService == null,
      ),
      SheetItem(
        title: const Text('下载'),
        onPressed: () {
          Provider.of<DownloadModel>(context, listen: false).download([item]);
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(musicOrder.name),
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
                    player.addPlayerList(musicOrder.musicList);
                    player.play(music: musicOrder.musicList[0]);
                  },
                ),
                SheetItem(
                  title: const Text('追加到播放列表'),
                  onPressed: () {
                    player.addPlayerList(musicOrder.musicList);
                  },
                ),
                SheetItem(
                  title: const Text('加入歌单'),
                  hidden: widget.umoService != null,
                  onPressed: () {
                    collectToMusicOrder(context, musicOrder.musicList);
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
          itemCount: musicOrder.musicList.length,
          itemBuilder: (context, index) {
            if (musicOrder.musicList.isEmpty) return null;
            final item = musicOrder.musicList[index];
            final List<String> tags = [
              item.origin.name,
              seconds2duration(item.duration),
            ];
            return ListTile(
              title: Text(item.name),
              subtitle: TextTags(tags: tags),
              onTap: () {
                Provider.of<PlayerModel>(context, listen: false)
                    .play(music: item);
              },
              trailing: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                child: const Icon(Icons.more_vert),
                onTap: () {
                  _moreHandler(context, item);
                },
              ),
            );
          }),
    );
  }
}
