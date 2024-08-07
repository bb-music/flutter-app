import 'dart:convert';

import 'package:bbmusic/modules/music_order/detail.dart';
import 'package:bbmusic/modules/open_music_order/config_view.dart';
import 'package:bbmusic/modules/open_music_order/utils.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpenMusicOrderListView extends StatefulWidget {
  const OpenMusicOrderListView({super.key});

  @override
  State<OpenMusicOrderListView> createState() => _OpenMusicOrderListViewState();
}

class _OpenMusicOrderListViewState extends State<OpenMusicOrderListView> {
  final List<MusicOrderItem> _list = [];
  final double _coverSize = 40;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _list.clear();
    final List<String> urls = await getMusicOrderUrl();
    // 并发请求多个接口
    await Future.wait(urls.map(getOrder));
  }

  Future<void> getOrder(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List<MusicOrderItem> l = [];
        data.forEach((item) {
          l.add(MusicOrderItem.fromJson(item));
        });
        setState(() {
          _list.addAll(l);
        });
      }
    } catch (e) {
      print(e);
      BotToast.showSimpleNotification(title: "歌单源错误");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("歌单广场"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const OpenMusicOrderConfigView();
                  },
                ));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView(
        children: _list.map((item) {
          return ListTile(
            title: Text(item.name),
            minTileHeight: _coverSize + 20,
            leading: SizedBox(
              width: _coverSize,
              height: _coverSize,
              child: Stack(
                children: [
                  Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: item.cover != null && item.cover!.isNotEmpty
                          ? Image.network(
                              item.cover!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: const Color.fromARGB(179, 209, 205, 205),
                            ),
                    ),
                  ),
                  Positioned(
                    child: Container(
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
                    ),
                  )
                ],
              ),
            ),
            subtitle: item.desc.isNotEmpty ? Text(item.desc) : const Text('-'),
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
