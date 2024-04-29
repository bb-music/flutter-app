import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:bbmusic/modules/player/service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/player/const.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';

class PlayerModel extends ChangeNotifier {
  // 播放器实例
  AudioPlayer? get _audio => _playerHandler?.player.audio;
  Duration? get duration => _audio?.duration;
  // 后台播放实例
  AudioHandler? _playerService;
  AudioPlayerHandler? _playerHandler;
  // 当前歌曲
  MusicItem? get current => _playerHandler?.current;
  // 歌曲是否加载
  bool get isLoading => _playerHandler?.player.isLoading ?? false;
  // 是否正在播放
  bool get isPlaying {
    return _playerHandler?.player.isPlaying ?? false;
  }

  // 播放列表
  List<MusicItem> get playerList {
    return _playerHandler?.player.playerList ?? [];
  }

  // 播放模式
  PlayerMode get playerMode {
    return _playerHandler?.player.playerMode ?? PlayerMode.listLoop;
  }

  init({
    required AudioPlayerHandler playerHandler,
    required AudioHandler playerService,
  }) async {
    // 后台服务
    _playerHandler = playerHandler;
    _playerService = playerService;
    await playerHandler.player.init();
    _audio?.playerStateStream.listen((event) {
      notifyListeners();
    });
  }

  // 播放
  Future<void> play({MusicItem? music}) async {
    await _playerHandler?.play(music: music);
    notifyListeners();
  }

  // 暂停
  Future<void> pause() async {
    await _playerService?.pause();
    notifyListeners();
  }

  // 上一首
  Future<void> prev() async {
    await _playerService?.skipToPrevious();
    notifyListeners();
  }

  // 下一首
  Future<void> next() async {
    await _playerService?.skipToNext();
    notifyListeners();
  }

  Future<void>? seek(Duration position) => _playerHandler?.seek(position);

  // 切换播放模式
  void togglePlayerMode({PlayerMode? mode}) {
    _playerHandler?.player.togglePlayerMode();
    notifyListeners();
  }

  // 添加到播放列表中
  void addPlayerList(List<MusicItem> musics) {
    _playerHandler?.player.addPlayerList(musics);
    notifyListeners();
  }

  // 在播放列表中移除
  void removePlayerList(List<MusicItem> musics) {
    _playerHandler?.player.removePlayerList(musics);
    notifyListeners();
  }

  // 清空播放列表
  void clearPlayerList() {
    _playerHandler?.player.clearPlayerList();
    notifyListeners();
  }

  // 监听播放进度
  StreamSubscription<Duration>? listenPosition(
    void Function(Duration)? onData,
  ) {
    return _audio?.positionStream.listen(onData);
  }
}
