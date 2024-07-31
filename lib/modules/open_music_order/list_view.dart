import 'dart:convert';

import 'package:bbmusic/modules/music_order/detail.dart';
import 'package:bbmusic/modules/open_music_order/config_view.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const _cacheKey = 'open_music_order_list';

class OpenMusicOrderListView extends StatefulWidget {
  const OpenMusicOrderListView({super.key});

  @override
  State<OpenMusicOrderListView> createState() => _OpenMusicOrderListViewState();
}

class _OpenMusicOrderListViewState extends State<OpenMusicOrderListView> {
  final List<MusicOrderItem> _list = [];
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _list.clear();
    final localStorage = await SharedPreferences.getInstance();
    final List<String> urls = localStorage.getStringList(_cacheKey) ??
        ["https://lvyueyang.github.io/bb-music-order-open/list.json"];
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
