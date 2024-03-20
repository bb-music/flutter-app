import 'package:just_audio/just_audio.dart' as audioplayers;
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.const.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:flutter_app/origin_sdk/service.dart';

class PlayerModel extends ChangeNotifier {
  // 播放器实例
  final audio = audioplayers.AudioPlayer();
  // 当前歌曲
  MusicItem? current;
  // 播放列表
  final List<MusicItem> playerList = [];
  // 已播放，用于计算随机
  final List<String> _playerHistory = [];
  // 播放器状态
  PlayerStatus playerStatus = PlayerStatus.stop;
  // 播放模式
  PlayerMode playerMode = PlayerMode.listLoop;

  PlayerModel() {
    audio.playerStateStream.listen((state) {
      if (state.playing) {
        _setStatus(PlayerStatus.play);
        playerStatus = PlayerStatus.play;
      } else {
        _setStatus(PlayerStatus.pause);
      }
      if (state.processingState == audioplayers.ProcessingState.loading) {
        _setStatus(PlayerStatus.loading);
      }
    });
    // audio.positionStream.listen((event) { })
  }

  // 播放
  void play(MusicItem? music) async {
    /**
     * 播放逻辑说明
     * 有 music
     *  判断是否存在于播放列表
     *    不存在 -> 添加
     *    存在 
     *  判断是否等于 current
     *    等于
     *      是否播放中
     *        是 -> 暂停
     *        否 -> 开始
     *    不等于
     *      设置为 current 并播放
     * 无 music
     *  判断 current
     *    有
     *      是否播放中
     *        是 -> 暂停
     *        否 -> 开始
     *    无
     *      判断播放列表是否为空
     *        不为空 => 选取播放列表中的第一个设置为 current 播放
     *        为空 -> 提示
     */
    if (music != null) {
      // 判断播放列表是否已存在
      if (playerList.where((e) => e.id == music.id).isEmpty) {
        // 不存在，添加到播放列表
        playerList.add(music);
      }

      if (current?.id != music.id) {
        current = music;
        await _play(music.id);
      } else {
        // 和 current 相等
        if (playerStatus == PlayerStatus.play) {
          // 播放中暂停
          audio.pause();
        } else {
          // 停止中恢复播放
          audio.play();
        }
      }
    } else {
      if (current != null) {
        if (playerStatus == PlayerStatus.play) {
          // 播放中暂停
          audio.pause();
        } else {
          // 停止中恢复播放
          audio.play();
        }
      } else {
        // 没有播放列表
        if (playerList.isNotEmpty) {
          // 播放列表不为空
          current = playerList.first;
          if (current != null) {
            await _play(current!.id);
          }
        } else {
          // 播放列表为空
        }
      }
    }

    notifyListeners();
  }

  _play(String id) async {
    MusicUrl musicUrl = await service.getMusicUrl(id);
    audio.setUrl(musicUrl.url, headers: musicUrl.headers);
    audio.play();
  }

  _setStatus(PlayerStatus status) {
    if (playerStatus == status) return;
    playerStatus = status;
    notifyListeners();
  }

  // 暂停
  void pause() {
    audio.pause();
    notifyListeners();
  }

  // 添加到播放列表中
  void addPlayerList(List<MusicItem> musics) {
    removePlayerList(musics);
    playerList.addAll(musics);
    notifyListeners();
  }

  // 在播放列表中移除
  void removePlayerList(List<MusicItem> musics) {
    playerList.removeWhere((w) => musics.where((e) => e.id == w.id).isNotEmpty);
    notifyListeners();
  }

  // 清空播放列表
  void clearPlayerList() {
    playerList.clear();
    notifyListeners();
  }
}
