import 'package:flutter/material.dart';

/// 播放状态
enum PlayerStatus {
  loading(value: -1, name: '加载中'),
  stop(value: 0, name: '停止'),
  play(value: 1, name: '播放中'),
  pause(value: 2, name: '暂停中');

  const PlayerStatus({required this.value, required this.name});
  final int value;
  final String name;
}

/// 播放模式
enum PlayerMode {
  signalLoop(
    value: 1,
    name: '单曲循环',
    icon: Icons.repeat_one,
  ),
  random(
    value: 2,
    name: '随机',
    icon: Icons.shuffle,
  ),
  listLoop(
    value: 3,
    name: '列表循环',
    icon: Icons.repeat,
  ),
  listOrder(
    value: 4,
    name: '顺序播放',
    icon: Icons.list,
  );

  const PlayerMode(
      {required this.value, required this.name, required this.icon});
  final int value;
  final String name;
  final IconData icon;
}
