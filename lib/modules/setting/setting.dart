import 'package:bbmusic/modules/setting/local_data.dart';
import 'package:bbmusic/modules/setting/music_order_origin/list_view.dart';
import 'package:flutter/material.dart';

final LocalDataManage localDataManage = LocalDataManage();

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('歌单源设置'),
            leading: const Icon(Icons.trip_origin_outlined),
            minTileHeight: 60,
            onTap: () {
              navigator.push(
                MaterialPageRoute(
                  builder: (context) {
                    return const MusicOrderOriginSetting();
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const ListTile(
            minTileHeight: 30,
            title: Text(
              "其他配置",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ListTile(
            title: const Text("数据导入"),
            leading: const Icon(Icons.upload),
            onTap: () {
              localDataManage.import(context);
            },
          ),
          ListTile(
            title: const Text("数据导出"),
            leading: const Icon(Icons.download),
            onTap: () {
              localDataManage.export(context);
            },
          ),
          ListTile(
            title: const Text("清理缓存"),
            leading: const Icon(Icons.cleaning_services),
            onTap: () {},
          ),
          ListTile(
            title: const Text("关于哔哔音乐"),
            leading: const Icon(Icons.info),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
