import 'package:bbmusic/database/database.dart';
import 'package:bbmusic/database/uuid.dart';
import 'package:bbmusic/modules/open_music_order/model.dart';
import 'package:bbmusic/modules/open_music_order/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenMusicOrderConfigView extends StatefulWidget {
  const OpenMusicOrderConfigView({super.key});

  @override
  State<OpenMusicOrderConfigView> createState() =>
      _OpenMusicOrderConfigViewState();
}

class _OpenMusicOrderConfigViewState extends State<OpenMusicOrderConfigView> {
  List<String> _list = [];
  final db = AppDatabase();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final list = await getMusicOrderUrl();
    setState(() {
      _list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OpenMusicOrderModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("歌单源配置"),
      ),
      body: ListView(
        children: _list
            .map(
              (e) => ListTile(
                title: Text(e),
                trailing: IconButton(
                  // 删除按钮
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    // 数据库删除
                    await db.managers.openMusicOrderUrlEntity
                        .filter((f) => f.url.equals(e))
                        .delete();
                    setState(() {
                      _list.remove(e);
                    });
                    model.reload();
                  },
                ),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("新增歌单源"),
                  ),
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 15,
                    ),
                    child: FilledButton(
                      onPressed: () async {
                        _list.add(_controller.text);
                        Navigator.of(context).pop();
                        await db.managers.openMusicOrderUrlEntity.create(
                          (o) => o(
                            id: generateUUID(),
                            url: _controller.text,
                          ),
                        );
                        model.reload();
                      },
                      child: const Text('添加'),
                    ),
                  ),
                  body: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("URL"),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
          },
          child: const Text("新增源"),
        ),
      ),
    );
  }
}
