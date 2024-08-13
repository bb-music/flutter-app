import 'dart:async';

import 'package:bbmusic/modules/download/model.dart';
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
                child: CachedNetworkImage(
                  imageUrl: player.current!.cover,
                  width: coverWidth,
                  height: coverWidth,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              // 下载，添加到歌单
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
                      onPressed: () {},
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
