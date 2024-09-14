import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/music_order/model.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

// 编辑/创建歌单
class EditMusicOrder extends StatefulWidget {
  final MusicOrderItem? data;
  final UserMusicOrderOrigin service;

  const EditMusicOrder({super.key, this.data, required this.service});

  @override
  State<EditMusicOrder> createState() => _EditMusicOrderState();
}

class _EditMusicOrderState extends State<EditMusicOrder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _coverController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool get _isCreate => widget.data?.id == "";

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
                  if (_isCreate) {
                    await widget.service.create(
                      MusicOrderItem(
                        id: '',
                        author: '',
                        name: _nameController.text,
                        desc: _descController.text,
                        cover: _coverController.text,
                        musicList: [],
                      ),
                    );
                  } else {
                    await widget.service.update(
                      MusicOrderItem(
                        id: widget.data!.id,
                        name: _nameController.text,
                        desc: _descController.text,
                        cover: _coverController.text,
                        author: widget.data!.author,
                        musicList: widget.data!.musicList,
                      ),
                    );
                  }
                  cancel();
                  if (context.mounted) {
                    Provider.of<UserMusicOrderModel>(context, listen: false)
                        .load(widget.service.name);
                    Navigator.of(context).pop();
                  }
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
