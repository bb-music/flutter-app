import 'dart:async';

import 'package:bbmusic/modules/download/model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/player/player.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/utils/clear_html_tags.dart';
import 'package:provider/provider.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key});
  @override
  Widget build(BuildContext context) {
    double coverWidth = 160;
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return Container(
          height: 460,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 歌曲名称
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                  bottom: 20,
                ),
                child: Text(
                  player.current!.name,
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // 封面
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: player.current?.cover != ""
                    ? CachedNetworkImage(
                        imageUrl: player.current!.cover,
                        width: coverWidth,
                        height: coverWidth,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: const Color.fromARGB(255, 227, 226, 226),
                        width: coverWidth,
                        height: coverWidth,
                        child: Center(
                          child: Text(
                            player.current!.name,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              // 下载，定时播放
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: "下载",
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        Provider.of<DownloadModel>(context, listen: false)
                            .download([player.current!]);
                      },
                      icon: const Icon(Icons.download),
                    ),
                  ),
                  Tooltip(
                    message: "定时关闭",
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        autoClose(context);
                      },
                      icon: const Icon(Icons.alarm),
                    ),
                  )
                ],
              ),
              // 进度
              const PlayerProgress(),
              // 播放模式、上一首，下一首，播放，列表
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ModeButton(size: 30),
                  PrevButton(size: 40),
                  PlayButton(size: 60),
                  NextButton(size: 40),
                  PlayerListButton(size: 30),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class PlayerProgress extends StatefulWidget {
  const PlayerProgress({
    super.key,
  });

  @override
  State<PlayerProgress> createState() => _PlayerProgressState();
}

class _PlayerProgressState extends State<PlayerProgress> {
  double _value = 0;
  bool _isChanged = false;
  List<StreamSubscription<Duration>?> listens = [];

  @override
  void initState() {
    final player = Provider.of<PlayerModel>(context, listen: false);
    super.initState();

    listens.add(player.listenPosition((event) {
      if (_isChanged || !mounted) return;
      double c = event.inSeconds.toDouble();
      double total = player.duration?.inSeconds.toDouble() ?? 0.0;
      double v = c / total;
      if (v.isNaN) return;
      if (v > 1.0) {
        v = 1.0;
      }
      if (v < 0.0) {
        v = 0;
      }
      setState(() {
        _value = v;
      });
    }));
  }

  @override
  void dispose() {
    for (final listen in listens) {
      listen?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerModel>(builder: (context, player, child) {
      int total = (player.duration?.inSeconds ?? 0);
      return Column(
        children: [
          Slider(
            value: _value,
            onChanged: (v) {
              setState(() {
                _value = v;
              });
            },
            onChangeStart: (value) {
              setState(() {
                _isChanged = true;
              });
            },
            onChangeEnd: (value) {
              final player = Provider.of<PlayerModel>(context, listen: false);
              int v = (value * total).toInt();
              player.seek(Duration(seconds: v));
              setState(() {
                _isChanged = false;
              });
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  seconds2duration((_value * total).toInt()),
                ),
                Text(seconds2duration(total)),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class AutoCloseItem {
  final String label;
  final Duration value;

  AutoCloseItem({required this.label, required this.value});
}

final List<AutoCloseItem> AutoCloseList = [
  AutoCloseItem(label: "1 分钟", value: const Duration(minutes: 1)),
  AutoCloseItem(label: "5 分钟", value: const Duration(minutes: 5)),
  AutoCloseItem(label: "10 分钟", value: const Duration(minutes: 10)),
  AutoCloseItem(label: "15 分钟", value: const Duration(minutes: 15)),
  AutoCloseItem(label: "30 分钟", value: const Duration(minutes: 30)),
  AutoCloseItem(label: "60 分钟", value: const Duration(minutes: 60)),
];

// 定时关闭
autoClose(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext ctx) {
      return SafeArea(
        bottom: true,
        child: Container(
          color: Theme.of(context).cardTheme.color,
          padding: const EdgeInsets.all(10),
          height: 200,
          width: double.infinity,
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 18,
                children: AutoCloseList.map((item) {
                  return OutlinedButton(
                    child: SizedBox(
                      width: 60,
                      child: Center(
                        child: Text(item.label),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      BotToast.showText(text: "${item.label}后自动关闭");
                      Provider.of<PlayerModel>(context, listen: false)
                          .autoCloseHandler(item.value);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<PlayerModel>(builder: (context, player, child) {
                    return Checkbox(
                      value: player.playDoneAutoClose,
                      onChanged: (e) {
                        player.togglePlayDoneAutoClose();
                      },
                    );
                  }),
                  const Text("当前歌曲播放完成后再关闭"),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
