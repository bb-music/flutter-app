import 'package:flutter/material.dart';
import 'package:flutter_app/modules/music_order/music_order_detail.dart';
import 'package:flutter_app/modules/user_music_order/common.dart';
import 'package:flutter_app/modules/user_music_order/user_music_order.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';

class UserMusicOrderView extends StatelessWidget {
  const UserMusicOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的歌单"),
      ),
      body: Column(
        children: [
          ...userMusicOrderOrigin.map((e) {
            return _MusicOrderListView(service: e);
          }),
        ],
      ),
    );
  }
}

class _MusicOrderListView extends StatefulWidget {
  final UserMusicOrderOrigin service;

  const _MusicOrderListView({super.key, required this.service});

  @override
  _MusicOrderListViewState createState() => _MusicOrderListViewState();
}

class _MusicOrderListViewState extends State<_MusicOrderListView> {
  List<MusicOrderItem> _list = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await widget.service.initConfig();
    final list = await widget.service.getList();
    setState(() {
      _list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _list.length * 80 + 80,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Text(widget.service.cname),
          ),
          Expanded(
            child: ListView(
              children: _list.map((item) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        print(item.musicList);
                        return MusicOrderDetail(data: item);
                      },
                    ));
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: item.cover != null && item.cover!.isNotEmpty
                        ? Image.network(
                            item.cover!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: const Color.fromARGB(179, 209, 205, 205),
                          ),
                  ),
                  title: Text(item.name),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
