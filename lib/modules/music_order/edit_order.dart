import 'package:bbmusic/modules/setting/music_order_origin/mode.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

// 编辑/创建歌单
class EditMusicOrder extends StatefulWidget {
  final MusicOrderItem? data;
  final UserMusicOrderOrigin service;
  String? originSettingId; // 歌单源配置 ID

  EditMusicOrder({
    super.key,
    this.data,
    this.originSettingId,
    required this.service,
  });

  @override
  State<EditMusicOrder> createState() => _EditMusicOrderState();
}

class _EditMusicOrderState extends State<EditMusicOrder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _coverController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool get _isCreate => (widget.data?.id == "" || widget.data == null);

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.data?.name ?? '';
      _descController.text = widget.data?.desc ?? '';
      _coverController.text = widget.data?.cover ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isCreate ? const Text('创建歌单') : const Text('修改歌单'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _coverController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("歌单封面"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("歌单名称"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("歌单描述"),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final cancel = BotToast.showLoading();
                  try {
                    if (_isCreate) {
                      final music = MusicOrderItem(
                        id: '',
                        author: '',
                        name: _nameController.text,
                        desc: _descController.text,
                        cover: _coverController.text,
                        musicList: [],
                      );
                      await widget.service.create(music);
                    } else {
                      final music = MusicOrderItem(
                        id: widget.data!.id,
                        name: _nameController.text,
                        desc: _descController.text,
                        cover: _coverController.text,
                        author: widget.data!.author,
                        musicList: widget.data!.musicList,
                      );
                      await widget.service.update(music);
                    }
                    if (context.mounted && widget.originSettingId != null) {
                      Provider.of<MusicOrderOriginSettingModel>(
                        context,
                        listen: false,
                      ).loadSignal(widget.originSettingId!);
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    BotToast.showText(
                      text: "${_isCreate ? "创建" : "更新"}失败 ${e.toString()}",
                    );
                  }
                  cancel();
                },
                child: const Text('确 认'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
