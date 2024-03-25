import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/sheet/bottom_sheet.dart';
import 'package:flutter_app/modules/music_order/detail.dart';
import 'package:flutter_app/modules/music_order/model.dart';
import 'package:flutter_app/modules/setting/setting.dart';
import 'package:flutter_app/modules/user_music_order/common.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

class UserMusicOrderView extends StatelessWidget {
  const UserMusicOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的歌单"),
      ),
      body: Consumer<UserMusicOrderModel>(
        builder: (context, umo, child) {
          return ListView(
            children: [
              ...umo.dataList.map((e) {
                return _MusicOrderListView(
                  umo: e,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _MusicOrderListView extends StatefulWidget {
  final UserMusicOrderOriginItem umo;

  const _MusicOrderListView({super.key, required this.umo});

  @override
  _MusicOrderListViewState createState() => _MusicOrderListViewState();
}

class _MusicOrderListViewState extends State<_MusicOrderListView> {
  List<MusicOrderItem> get _list => widget.umo.list;

  _formItemHandler(MusicOrderItem? data) {
    if (!widget.umo.service.canUse()) {
      BotToast.showSimpleNotification(
        title: "歌单源目前无法使用,请先完善配置",
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditMusicOrder(
        service: widget.umo.service,
        data: data,
      );
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _emptyBuild() {
    return SizedBox(
      height: 60,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('歌单源目前无法使用,请先'),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  final settingWidget = widget.umo.service.configBuild();
                  if (settingWidget != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return settingWidget;
                        },
                      ),
                    );
                  }
                },
                child: const Text('完善配置'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canUse = widget.umo.service.canUse();
    return SizedBox(
      height: (canUse ? _list.length * 65 : 60) + 70,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: Theme.of(context).hoverColor,
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 5,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.umo.service.cname,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Visibility(
                  visible: canUse,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _formItemHandler(null);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: !canUse
                ? _emptyBuild()
                : ListView(
                    children: _list.map((item) {
                      gotoDetail() {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MusicOrderDetail(data: item);
                          },
                        ));
                      }

                      return ListTile(
                        onTap: gotoDetail,
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
                                  color:
                                      const Color.fromARGB(179, 209, 205, 205),
                                ),
                        ),
                        title: Text(item.name),
                        subtitle: item.desc.isNotEmpty
                            ? Text(item.desc)
                            : const Text('-'),
                        onLongPress: () {
                          openBottomSheet(context, [
                            SheetItem(
                              title: const Text('查看歌单'),
                              onPressed: gotoDetail,
                            ),
                            SheetItem(
                              title: const Text('编辑歌单'),
                              onPressed: () {
                                _formItemHandler(item);
                              },
                            ),
                            SheetItem(
                              title: const Text('删除歌单'),
                              onPressed: () {
                                widget.umo.service.delete(item).then((value) {
                                  BotToast.showSimpleNotification(title: "已删除");
                                  Provider.of<UserMusicOrderModel>(
                                    context,
                                    listen: false,
                                  ).load(widget.umo.service.name);
                                });
                              },
                            ),
                          ]);
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

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
  final TextEditingController _descController = TextEditingController();

  bool get _isCreate => widget.data == null;

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.data?.name ?? '';
      _descController.text = widget.data?.desc ?? '';
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
                        name: _nameController.text,
                        desc: _descController.text,
                        author: '',
                        musicList: [],
                      ),
                    );
                  } else {
                    await widget.service.update(
                      MusicOrderItem(
                        id: widget.data!.id,
                        name: _nameController.text,
                        desc: _descController.text,
                        cover: widget.data!.cover,
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
