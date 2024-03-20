import 'dart:math';

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
      } else {
        _setStatus(PlayerStatus.pause);
      }
      if (state.processingState == audioplayers.ProcessingState.loading) {
        _setStatus(PlayerStatus.loading);
      }
      if (state.processingState == audioplayers.ProcessingState.completed) {
        _setStatus(PlayerStatus.pause);
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
        _addPlayerHistory();
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
            _addPlayerHistory();
          }
        } else {
          // 播放列表为空
        }
      }
    }
    notifyListeners();
  }

  // 暂停
  void pause() {
    audio.pause();
    notifyListeners();
  }

  // 上一首
  void prev() {
    audio.seek(Duration.zero);
    if (current != null) {
      int ind = _playerHistory.indexOf(current!.id);
      if (ind > 0) {
        String prevId = _playerHistory[ind - 1];
        MusicItem? m = playerList.firstWhere((e) => e.id == prevId);
        m ?? play(m);
      }
    }
  }

  // 下一首
  void next() {
    if (current == null) return;
    audio.seek(Duration.zero);
    if (playerMode == PlayerMode.random) {
      endNext();
    } else {
      int index = playerList.indexWhere((p) => p.id == current!.id);
      if (index == playerList.length - 1) return;
      play(playerList[index + 1]);
    }
  }

  // 结束播放
  void endNext() {
    if (current == null) return;

    signalLoop() {
      audio.seek(Duration.zero);
      play(current);
    }

    // 单曲循环
    if (playerMode == PlayerMode.signalLoop) {
      signalLoop();
      return;
    }
    // 随机
    if (playerMode == PlayerMode.random) {
      List<MusicItem> list =
          playerList.where((p) => !_playerHistory.contains(p.id)).toList();
      int len = list.length;

      if (len == 0) {
        _playerHistory.clear();
        int nn = playerList.length;
        var r = Random().nextInt(nn);
        play(playerList[r]);
      } else {
        var r = Random().nextInt(len);
        play(list[r]);
      }
      return;
    }
    int index = playerList.indexWhere((p) => p.id == current!.id);
    // 列表顺序播放
    if (playerMode == PlayerMode.listOrder) {
      if (index != playerList.length - 1) {
        play(playerList[index + 1]);
      }
      // 列表顺序结尾停止
    }
    // 列表循环
    if (playerMode == PlayerMode.listLoop) {
      if (playerList.length == 1) {
        // 只有一个时就是单曲循环
        signalLoop();
      } else if (index == playerList.length - 1) {
        play(playerList[0]);
      } else {
        play(playerList[index + 1]);
      }
    }
  }

  // 切换播放模式
  void togglePlayerMode(PlayerMode? mode) {
    if (mode != null) {
      playerMode = mode;
    } else {
      const l = [
        PlayerMode.signalLoop,
        PlayerMode.listLoop,
        PlayerMode.random,
        PlayerMode.listLoop,
      ];
      int index = l.indexWhere((p) => playerMode == p);

      if (index == l.length - 1) {
        playerMode = l[0];
      } else {
        playerMode = l[index + 1];
      }
    }
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

  // 添加到播放历史（用于随机播放）
  void _addPlayerHistory() {
    if (current != null) {
      _playerHistory.removeWhere((e) => e == current!.id);
      _playerHistory.add(current!.id);
    }
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
}
