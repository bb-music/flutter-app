import 'package:bbmusic/modules/music_order/list.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/music_order/model.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

// 收藏到歌单
collectToMusicOrder(
  BuildContext context,
  List<MusicItem> musics, {
  MusicOrderItem? musicOrder,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height - 80,
    ),
    builder: (ctx) {
      return UserMusicOrderList(
        musicOrder: MusicOrderItem(
          author: "",
          id: "",
          name: musicOrder?.name ?? "",
          desc: musicOrder?.desc ?? "",
          cover: musicOrder?.cover ?? "",
          musicList: musicOrder?.musicList ?? [],
        ),
        collectModalStyle: true,
        onItemTap: (UserMusicOrderOriginItem umo, MusicOrderItem data) async {
          final cancel = BotToast.showLoading();
          try {
            await umo.service.appendMusic(data.id, musics);
            if (context.mounted) {
              BotToast.showText(text: '添加成功');
              Provider.of<UserMusicOrderModel>(context, listen: false)
                  .load(umo.service.name);
              Navigator.of(context).pop();
            }
          } catch (e) {
            BotToast.showText(
              text: '添加失败 $e',
              duration: const Duration(seconds: 5),
            );
            rethrow;
          }
          cancel();
        },
      );
    },
  );
}
