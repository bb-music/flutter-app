import 'package:bbmusic/components/sheet/bottom_sheet.dart';
import 'package:bbmusic/modules/setting/music_order_origin/mode.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/modules/user_music_order/local/constants.dart';
import 'package:bbmusic/modules/user_music_order/user_music_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicOrderOriginSetting extends StatefulWidget {
  const MusicOrderOriginSetting({super.key});

  @override
  State<MusicOrderOriginSetting> createState() =>
      _MusicOrderOriginSettingState();
}

class _MusicOrderOriginSettingState extends State<MusicOrderOriginSetting> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('歌单源设置'),
      ),
      body: Consumer<MusicOrderOriginSettingModel>(
        builder: (context, store, child) {
          return ListView(
            children: store.list
                .where((w) => w.name != LocalOriginConst.name)
                .map((item) {
              moreHandler() {
                openBottomSheet(context, [
                  SheetItem(
                    title: const Text('删除'),
                    onPressed: () {
                      store.delete(item.id);
                    },
                  ),
                ]);
              }

              return ListTile(
                title: Text(item.subName),
                subtitle: Text(item.name),
                trailing: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: moreHandler,
                  child: const Icon(Icons.more_vert),
                ),
                onLongPress: moreHandler,
                onTap: () {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ConfigView(name: item.name, value: item);
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          child: const Text("新增"),
          onPressed: () {
            openBottomSheet(context, [
              ...userMusicOrderOrigin.values.map((e) {
                final data = e();
                return SheetItem(
                  title: Text('添加 ${data.cname} 歌单源'),
                  icon: Icon(data.icon),
                  hidden: data.name == LocalOriginConst.name,
                  onPressed: () {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ConfigView(name: data.name);
                        },
                      ),
                    );
                  },
                );
              })
            ]);
          },
        ),
      ),
    );
  }
}

class ConfigView extends StatefulWidget {
  final OriginSettingItem? value;
  final String name;

  const ConfigView({super.key, required this.name, this.value});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  final TextEditingController _subNameController = TextEditingController();
  Map<String, dynamic> _config = {};

  UserMusicOrderOrigin get originInfo {
    return userMusicOrderOrigin[widget.name]!();
  }

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _subNameController.text = widget.value!.subName;
      _updateConfig(widget.value!.config);
    }
  }

  _saveHandler() async {}

  _updateConfig(Map<String, dynamic> config) {
    _config = config;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(originInfo.cname),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: Column(
          children: [
            TextField(
              controller: _subNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("名称"),
              ),
            ),
            const SizedBox(height: 20),
            originInfo.configBuild(onChange: _updateConfig, value: _config) ??
                const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () async {
            await _saveHandler();
            if (context.mounted) {
              final store = Provider.of<MusicOrderOriginSettingModel>(context,
                  listen: false);
              if (widget.value == null) {
                store.add(widget.name, _subNameController.text, _config);
              } else {
                store.update(
                    widget.value!.id, _subNameController.text, _config);
              }
              Navigator.of(context).pop();
            }
          },
          child: widget.value == null ? const Text("保 存") : const Text("更 新"),
        ),
      ),
    );
  }
}
