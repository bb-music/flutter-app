import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cacheKey = 'open_music_order_list';

class OpenMusicOrderConfigView extends StatefulWidget {
  const OpenMusicOrderConfigView({super.key});

  @override
  State<OpenMusicOrderConfigView> createState() =>
      _OpenMusicOrderConfigViewState();
}

class _OpenMusicOrderConfigViewState extends State<OpenMusicOrderConfigView> {
  List<String> list = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final localStorage = await SharedPreferences.getInstance();
    setState(() {
      list = localStorage.getStringList(_cacheKey) ??
          [
            "https://lvyueyang.github.io/bb-music-order-open/list.json",
          ];
    });
  }

  _saveHandler() async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setStringList(_cacheKey, list);
    BotToast.showText(text: '保存成功');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("歌单源配置"),
      ),
      body: ListView(
        children: list
            .map(
              (e) => ListTile(
                title: Text(e),
                trailing: const Icon(Icons.delete_outline),
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
                      onPressed: () {},
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
