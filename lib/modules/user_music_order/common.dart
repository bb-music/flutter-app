import 'package:flutter/material.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';

abstract class UserMusicOrderOrigin {
  String get name => '';
  String get cname => '';
  IconData? get icon => null;

  /// 初始化歌单源的配置信息
  Widget? configBuild();

  /// 能否使用此歌单源
  bool canUse();

  /// 初始化所需配置
  Future<void> initConfig();

  /// 获取歌单列表
  Future<List<MusicOrderItem>> getList();

  /// 创建歌单
  Future<void> create(MusicOrderItem item);

  /// 更新歌单
  Future<void> update(MusicOrderItem item);

  /// 删除歌单
  Future<void> delete(MusicOrderItem item);

  // /// 歌单详情
  // Future<MusicOrderItem> getDetail(String id);

  // /// 添加歌曲
  // Future<MusicOrderItem> appendMusic(String id, List<MusicOrderItem> musics);

  // /// 更新歌曲
  // Future<MusicOrderItem> updateMusic(String id, List<MusicOrderItem> musics);

  // /// 移除歌曲
  // Future<MusicOrderItem> deleteMusic(String id, List<MusicOrderItem> musics);
}
