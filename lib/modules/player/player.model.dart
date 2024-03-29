import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.const.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:flutter_app/origin_sdk/service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKeyCurrent = 'player_current';
const _storageKeyPlayerList = 'player_player_list';
const _storageKeyHistoryList = 'player_history_list';
const _storageKeyPlayerMode = 'player_player_mode';

class PlayerModel extends ChangeNotifier {
  // 计时器
  Timer? _timer;
  // 播放器实例
  final audio = AudioPlayer();
  // 当前歌曲
  MusicItem? current;
  // 歌曲是否加载
  bool isLoading = false;
  // 播放列表
  final List<MusicItem> playerList = [];
  // 已播放，用于计算随机
  final List<String> _playerHistory = [];
  // 播放器状态
  PlayerStatus playerStatus = PlayerStatus.stop;
  // 播放模式
  PlayerMode playerMode = PlayerMode.listLoop;

  init() {
    _initLocalStorage();
    audio.playerStateStream.listen((state) {
      // print("====== START =======");
      // print(state);
      // print("====== END ========");
      if (state.playing) {
        _setStatus(PlayerStatus.play);
      } else {
        _setStatus(PlayerStatus.pause);
      }
      // var Function closeLoading = () {};
      if (state.processingState == ProcessingState.loading) {
        // closeLoading = BotToast.showLoading();
        isLoading = true;
        notifyListeners();
      }
      if (state.processingState == ProcessingState.ready) {
        // closeLoading();
        isLoading = false;
        notifyListeners();
      }
      if (state.processingState == ProcessingState.completed) {
        endNext();
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
          print("============= 停止中恢复播放1 ============");
          print(audio.audioSource);
          _play(null);
        }
      }
    } else {
      if (current != null) {
        if (playerStatus == PlayerStatus.play) {
          // 播放中暂停
          audio.pause();
        } else {
          // 停止中恢复播放
          print("============= 停止中恢复播放2 ============");
          print(audio.audioSource);
          _play(null);
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
    _updateLocalStorage();
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
        MusicItem m = playerList.firstWhere((e) => e.id == prevId);
        play(m);
      }
    }
    _updateLocalStorage();
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
      _updateLocalStorage();
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
      _updateLocalStorage();
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
      _updateLocalStorage();
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
    _updateLocalStorage();
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
        PlayerMode.listOrder,
      ];
      int index = l.indexWhere((p) => playerMode == p);

      if (index == l.length - 1) {
        playerMode = l[0];
      } else {
        playerMode = l[index + 1];
      }
    }
    _updateLocalStorage();
    notifyListeners();
  }

  // 添加到播放列表中
  void addPlayerList(List<MusicItem> musics) {
    removePlayerList(musics);
    playerList.addAll(musics);
    _updateLocalStorage();
    notifyListeners();
  }

  // 在播放列表中移除
  void removePlayerList(List<MusicItem> musics) {
    playerList.removeWhere((w) => musics.where((e) => e.id == w.id).isNotEmpty);
    _updateLocalStorage();
    notifyListeners();
  }

  // 清空播放列表
  void clearPlayerList() {
    playerList.clear();
    _updateLocalStorage();
    notifyListeners();
  }

  // 添加到播放历史（用于随机播放）
  void _addPlayerHistory() {
    if (current != null) {
      _playerHistory.removeWhere((e) => e == current!.id);
      _playerHistory.add(current!.id);
    }
  }

  _play(String? id) async {
    if (id != null) {
      audio.setAudioSource(CustomAudioSource(music: current!));
    }

    audio.play();
  }

  _setStatus(PlayerStatus status) {
    if (playerStatus == status) return;
    playerStatus = status;
    notifyListeners();
  }

  // 更新缓存
  _updateLocalStorage() {
    _timer?.cancel();
    _timer = Timer(const Duration(microseconds: 500), () async {
      final localStorage = await SharedPreferences.getInstance();
      // json 编码
      localStorage.setString(
        _storageKeyCurrent,
        current != null ? jsonEncode(current) : "",
      );
      localStorage.setString(
        _storageKeyPlayerMode,
        playerMode.value.toString(),
      );
      localStorage.setStringList(
        _storageKeyHistoryList,
        _playerHistory,
      );
      localStorage.setStringList(
        _storageKeyPlayerList,
        playerList.map((e) => jsonEncode(e)).toList(),
      );
    });
  }

  // 读取缓存
  _initLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();

    // json 编码
    String? c = localStorage.getString(_storageKeyCurrent);
    if (c != null && c.isNotEmpty) {
      var data = jsonDecode(c) as Map<String, dynamic>;
      String id = data['id'];
      current = MusicItem(
        id: id,
        name: data['name'],
        cover: data['cover'],
        author: data['author'],
        duration: data['duration'],
        origin: OriginType.getByValue(data['origin']),
      );
      audio.setAudioSource(CustomAudioSource(music: current!));
    }
    String? m = localStorage.getString(_storageKeyPlayerMode);
    if (m != null && m.isNotEmpty) {
      playerMode = PlayerMode.getByValue(int.parse(m));
    }

    List<String>? h = localStorage.getStringList(_storageKeyHistoryList);
    if (h != null && h.isNotEmpty) {
      _playerHistory.clear();
      _playerHistory.addAll(h);
    }

    List<String>? pl = localStorage.getStringList(_storageKeyPlayerList);
    if (pl != null && pl.isNotEmpty) {
      playerList.clear();
      for (var e in pl) {
        var data = jsonDecode(e) as Map<String, dynamic>;
        playerList.add(
          MusicItem(
            id: data['id'],
            name: data['name'],
            cover: data['cover'],
            author: data['author'],
            duration: data['duration'],
            origin: OriginType.getByValue(data['origin']),
          ),
        );
      }
    }

    notifyListeners();
  }
}

class CustomAudioSource extends StreamAudioSource {
  final List<int> _bytes = [];
  int _sourceLength = 0;
  String _contentType = 'video/mp4';
  final MusicItem music;
  bool _isInit = false;
  @override
  MediaItem get tag {
    return MediaItem(
      id: music.id,
      title: music.name,
      artUri: Uri.parse(music.cover),
    );
  }

  static Future<http.StreamedResponse> getMusicStream(
    MusicItem music,
    Function(List<int> data) callback,
  ) {
    // print('getMusicStream');
    final completer = Completer<http.StreamedResponse>();

    service.getMusicUrl(music.id).then((musicUrl) {
      var request = http.Request('GET', Uri.parse(musicUrl.url));
      request.headers.addAll(musicUrl.headers ?? {});
      http.Client client = http.Client();
      // StreamSubscription videoStream;
      client.send(request).then((response) {
        var isStart = false;
        response.stream.listen((List<int> data) {
          callback(data);
          if (!isStart) {
            completer.complete(response);
            isStart = true;
          }
          // TODO 后续加个缓存方法
        });
      }).catchError((error) {
        completer.completeError(error);
      });
    }).catchError((error) {
      completer.completeError(error);
    });
    return completer.future;
  }

  CustomAudioSource({required this.music});

  _init() async {
    if (_isInit) return;
    var resp = await CustomAudioSource.getMusicStream(music, (List<int> data) {
      _bytes.addAll(data);
    });
    _sourceLength = resp.contentLength ?? 0;
    _contentType = resp.headers['content-type'] ?? 'video/mp4';
    _isInit = true;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    await _init();
    start ??= 0;
    end ??= _bytes.length;

    return StreamAudioResponse(
      sourceLength: _sourceLength,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_bytes.sublist(start, end)),
      contentType: _contentType,
    );
  }
}
