import 'package:bbmusic/components/infinite_rotate/comp.dart';
import 'package:bbmusic/modules/music_order/detail.dart';
import 'package:bbmusic/modules/open_music_order/config_view.dart';
import 'package:bbmusic/modules/open_music_order/model.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final dio = Dio();

class OpenMusicOrderListView extends StatefulWidget {
  const OpenMusicOrderListView({super.key});

  @override
  State<OpenMusicOrderListView> createState() => _OpenMusicOrderListViewState();
}

class _OpenMusicOrderListViewState extends State<OpenMusicOrderListView> {
  final double _coverSize = 40;

  @override
  void initState() {
    super.initState();

    var store = Provider.of<OpenMusicOrderModel>(context, listen: false);
    if (store.dataList.isEmpty) {
      store.load();
    }
  }

  final refreshIcon = const Icon(
    Icons.refresh,
    color: Colors.white,
    size: 30,
  );

  // 设置按钮
  Widget builderSettingButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return const OpenMusicOrderConfigView();
          },
        ));
      },
      icon: const Icon(Icons.settings),
    );
  }

  // 歌单封面
  Widget builderCover(MusicOrderItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: item.cover != null && item.cover!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: item.cover!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(179, 209, 205, 205),
            ),
    );
  }

  // 信息
  Widget builderInfo(MusicOrderItem item) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromRGBO(0, 0, 0, 0.4),
      alignment: AlignmentDirectional.center,
      child: Text(
        item.musicList.length.toString(),
        style: const TextStyle(
          height: 1,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenMusicOrderModel>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("歌单广场"),
            actions: [
              builderSettingButton(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              store.reload();
            },
            child: store.loading
                ? InfiniteRotate(child: refreshIcon)
                : refreshIcon,
          ),
          body: ListView(
            children: store.dataList.map((item) {
              return ListTile(
                title: Text(item.name),
                minTileHeight: _coverSize + 20,
                leading: SizedBox(
                  width: _coverSize,
                  height: _coverSize,
                  child: Stack(
                    children: [
                      Positioned(
                        child: builderCover(item),
                      ),
                      Positioned(
                        child: builderInfo(item),
                      )
                    ],
                  ),
                ),
                subtitle:
                    item.desc.isNotEmpty ? Text(item.desc) : const Text('-'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MusicOrderDetail(
                        data: item,
                      );
                    },
                  ));
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

/// 签名秘钥
class OrderListGroup {
  const OrderListGroup();
  factory OrderListGroup.fromJson(Map<String, dynamic> json) {
    print(json);
    return OrderListGroup();
  }
}
