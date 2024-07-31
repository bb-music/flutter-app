import 'package:bbmusic/modules/open_music_order/list_view.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/music_order/list.dart';
import 'package:bbmusic/modules/open_music_order/config_view.dart';
import 'package:bbmusic/modules/player/player.dart';
import 'package:bbmusic/modules/search/search.dart';
import 'package:bbmusic/modules/setting/setting.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("哔哔音乐"),
        centerTitle: true,
      ),
      floatingActionButton: const PlayerView(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(
          children: [
            _ItemCard(
              icon: Icons.search,
              title: '搜索',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SearchView();
                    },
                  ),
                );
              },
            ),
            _ItemCard(
              icon: Icons.diversity_2,
              title: '广场',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const OpenMusicOrderListView();
                    },
                  ),
                );
              },
            ),
            _ItemCard(
              icon: Icons.person_4_outlined,
              title: '我的歌单',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const UserMusicOrderView();
                    },
                  ),
                );
              },
            ),
            _ItemCard(
              icon: Icons.settings,
              title: '设置',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SettingView();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function? onTap;

  const _ItemCard({
    super.key,
    this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
