import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/modules/player/const.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _storageKeyCurrent = CacheKey.playerCurrent;
final _storageKeyPlayerList = CacheKey.playerList;
final _storageKeyHistoryList = CacheKey.playerHistoryList;
final _storageKeyPlayerMode = CacheKey.playerMode;
final _storageKeyPosition = CacheKey.playerPosition;

class BBPlayer {
  // 计时器
  Timer? _timer;
  // 歌曲是否加载
  bool isLoading = false;
  // 是否正在播放
  bool get isPlaying {
    return audio.playing;
  }

  // 播放器实例
  final audio = AudioPlayer();
  // 当前歌曲
  MusicItem? current;
  // 播放列表
  final List<MusicItem> playerList = [];
  // 已播放，用于计算随机
  final List<String> _playerHistory = [];
  // 播放模式
  PlayerMode playerMode = PlayerMode.listLoop;

  Future<void> init() async {
    await _initLocalStorage();
    // 监听播放状态
    audio.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.loading) {
        isLoading = true;
      }
      if (state.processingState == ProcessingState.ready) {
        isLoading = false;
      }
      if (state.processingState == ProcessingState.completed) {
        endNext();
      }
      // notifyListeners();
    });

    // 记住播放进度
    var t = DateTime.now();
    audio.positionStream.listen((event) {
      var n = DateTime.now();
      if (t.add(const Duration(seconds: 5)).isBefore(n)) {
        _cachePosition();
        t = n;
      }
    });
  }

  // 销毁
  void dispose() {
    audio.dispose();
    _timer?.cancel();
  }

  // 播放
  Future<void> play({MusicItem? music}) async {
    print('PLAY');
    if (music != null) {
      // 判断播放列表是否已存在
      if (playerList.where((e) => e.id == music.id).isEmpty) {
        // 不存在，添加到播放列表
        addPlayerList([music]);
      }

      if (current?.id != music.id) {
        current = music;
        // notifyListeners();
        _updateLocalStorage();
        print("播放新歌曲");
        await audio.seek(Duration.zero);
        await _play(id: music.id);
        _addPlayerHistory();
      } else {
        // 和 current 相等
        if (isPlaying) {
          // 播放中暂停
          await audio.pause();
        } else {
          // 暂停中恢复播放
          print("暂停中恢复播放1");
          await _play();
        }
      }
    } else {
      if (current != null) {
        if (isPlaying) {
          // 播放中暂停
          await audio.pause();
        } else {
          // 停止中恢复播放
          print("停止中恢复播放2");
          await _play();
        }
      } else {
        // 没有播放列表
        if (playerList.isNotEmpty) {
          // 播放列表不为空
          current = playerList.first;
          // notifyListeners();
          _updateLocalStorage();
          if (current != null) {
            await _play(id: current!.id);
            _addPlayerHistory();
          }
        }
      }
    }
    // notifyListeners();
    _updateLocalStorage();
  }

  // 暂停
  Future<void> pause() async {
    await audio.pause();
    // notifyListeners();
  }

  // 上一首
  Future<void> prev() async {
    await audio.seek(Duration.zero);
    if (current != null) {
      int ind = _playerHistory.indexOf(current!.id);
      if (ind > 0) {
        String prevId = _playerHistory[ind - 1];
        final ms = playerList.where((e) => e.id == prevId);
        if (ms.isNotEmpty) {
          await play(music: ms.first);
        }
      }
    }
    _updateLocalStorage();
  }

  // 下一首
  Future<void> next() async {
    if (current == null) return;
    if (playerMode != PlayerMode.signalLoop) {
      await endNext();
    } else {
      int index = playerList.indexWhere((p) => p.id == current!.id);
      await audio.seek(Duration.zero);
      if (playerList.length == 1) {
        // 只有一个时就是单曲循环
        await play(music: current);
      } else if (index == playerList.length - 1) {
        await play(music: playerList[0]);
      } else {
        await play(music: playerList[index + 1]);
      }
    }
    _updateLocalStorage();
  }

  // 结束播放
  Future<void> endNext() async {
    if (current == null) return;

    signalLoop() async {
      await audio.seek(Duration.zero);
      await play(music: current);
    }

    // 单曲循环
    if (playerMode == PlayerMode.signalLoop) {
      await signalLoop();
      _updateLocalStorage();
      return;
    }
    // 随机
    if (playerMode == PlayerMode.random) {
      List<MusicItem> list =
          playerList.where((p) => !_playerHistory.contains(p.id)).toList();
      int len = list.length;
      await audio.seek(Duration.zero);
      if (len == 0) {
        _playerHistory.clear();
        int nn = playerList.length;
        var r = Random().nextInt(nn);
        await play(music: playerList[r]);
      } else {
        var r = Random().nextInt(len);
        await play(music: list[r]);
      }
      _updateLocalStorage();
      return;
    }
    int index = playerList.indexWhere((p) => p.id == current!.id);
    // 列表顺序播放
    if (playerMode == PlayerMode.listOrder) {
      if (index != playerList.length - 1) {
        await audio.seek(Duration.zero);
        await play(music: playerList[index + 1]);
      }
      // 列表顺序结尾停止
    }
    // 列表循环
    if (playerMode == PlayerMode.listLoop) {
      await audio.seek(Duration.zero);
      if (playerList.length == 1) {
        // 只有一个时就是单曲循环
        await signalLoop();
      } else if (index == playerList.length - 1) {
        await play(music: playerList[0]);
      } else {
        await play(music: playerList[index + 1]);
      }
    }
    _updateLocalStorage();
  }

  // 切换播放模式
  void togglePlayerMode({PlayerMode? mode}) {
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
    // notifyListeners();
  }

  // 添加到播放列表中
  void addPlayerList(List<MusicItem> musics) {
    removePlayerList(musics);
    playerList.addAll(musics);
    _updateLocalStorage();
    // notifyListeners();
  }

  // 在播放列表中移除
  void removePlayerList(List<MusicItem> musics) {
    playerList.removeWhere((w) => musics.where((e) => e.id == w.id).isNotEmpty);
    _updateLocalStorage();
    // notifyListeners();
  }

  // 清空播放列表
  void clearPlayerList() {
    playerList.clear();
    _updateLocalStorage();
    // notifyListeners();
  }

  // 添加到播放历史（用于随机播放）
  void _addPlayerHistory() {
    if (current != null) {
      _playerHistory.removeWhere((e) => e == current!.id);
      _playerHistory.add(current!.id);
    }
  }

  Future<void> _play({String? id}) async {
    if (id != null) {
      MusicUrl musicUrl = await service.getMusicUrl(id);
      await audio.setUrl(musicUrl.url, headers: musicUrl.headers);
    }
    await audio.play();
  }

  // 缓存播放进度
  Future<void> _cachePosition() async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setInt(
      _storageKeyPosition,
      audio.position.inMilliseconds,
    );
  }

  // 更新缓存
  void _updateLocalStorage() {
    _timer?.cancel();
    _timer = Timer(const Duration(microseconds: 500), () async {
      final localStorage = await SharedPreferences.getInstance();
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
  Future<void> _initLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    // 当前歌曲
    String? c = localStorage.getString(_storageKeyCurrent);
    if (c != null && c.isNotEmpty) {
      var data = jsonDecode(c) as Map<String, dynamic>;
      current = MusicItem(
        id: data['id'],
        name: data['name'],
        cover: data['cover'],
        author: data['author'],
        duration: data['duration'],
        origin: OriginType.getByValue(data['origin']),
      );
      service.getMusicUrl(current!.id).then((musicUrl) {
        audio.setUrl(musicUrl.url, headers: musicUrl.headers);
        // 设置播放进度
        final pos = localStorage.getInt(_storageKeyPosition) ?? 0;
        if (pos > 0) {
          audio.seek(Duration(milliseconds: pos));
        }
      });
    }

    // 播放模式
    String? m = localStorage.getString(_storageKeyPlayerMode);
    if (m != null && m.isNotEmpty) {
      playerMode = PlayerMode.getByValue(int.parse(m));
    }

    // 播放历史
    List<String>? h = localStorage.getStringList(_storageKeyHistoryList);
    if (h != null && h.isNotEmpty) {
      _playerHistory.clear();
      _playerHistory.addAll(h);
    }

    // 播放列表
    List<String>? pl = localStorage.getStringList(_storageKeyPlayerList);
    if (pl != null && pl.isNotEmpty) {
      clearPlayerList();
      List<MusicItem> musics = [];
      for (var e in pl) {
        var data = jsonDecode(e) as Map<String, dynamic>;
        musics.add(
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
      addPlayerList(musics);
    }

    // notifyListeners();
  }
}
