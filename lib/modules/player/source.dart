import 'dart:async';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:bbmusic/utils/logs.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';

final audioCacheManage = CacheManager(Config("bbmusicMediaCache"));

class BBMusicSource extends StreamAudioSource {
  final List<int> _bytes = [];
  int? _sourceLength;
  String _contentType = 'video/mp4';
  final MusicItem music;
  bool _isInit = false;
  String get _cacheKey => music2cacheKey(music);

  @override
  MediaItem get tag {
    return MediaItem(
      id: music.id,
      title: music.name,
      artUri: Uri.parse(music.cover),
    );
  }

  Future<StreamedResponse> getMusicStream(
    MusicItem music,
    Function(List<int> data) callback,
  ) async {
    final completer = Completer<StreamedResponse>();

    service.getMusicUrl(music.id).then((musicUrl) {
      var request = Request('GET', Uri.parse(musicUrl.url));
      request.headers.addAll(musicUrl.headers ?? {});
      Client client = Client();
      client.send(request).then((response) {
        var isStart = false;
        response.stream.listen((List<int> data) {
          callback(data);
          if (!isStart) {
            completer.complete(response);
            isStart = true;
          }
        }, onDone: () async {
          // 缓冲完成将歌曲添加到缓存
          var bytes = Uint8List.fromList(_bytes);
          var ext = musicUrl.url.split('?').first.split('.').last;
          await audioCacheManage.putFile(
            musicUrl.url,
            bytes,
            key: _cacheKey,
            fileExtension: ext,
            maxAge: const Duration(days: 365 * 100),
          );
        }, onError: (error) {
          completer.completeError(error);
        });
      }).catchError((error) {
        completer.completeError(error);
      });
    }).catchError((error) {
      completer.completeError(error);
    });
    return completer.future;
  }

  BBMusicSource(this.music);

  _init() async {
    if (_isInit) return;
    try {
      var resp = await getMusicStream(music, (List<int> data) {
        _bytes.addAll(data);
      });
      _sourceLength = resp.contentLength;
      _contentType = resp.headers['content-type'] ?? 'video/mp4';
      _isInit = true;
    } catch (e) {
      BotToast.showText(text: '加载失败');
      logs.e("加载失败", error: e);
      rethrow;
    }
  }

  Future<StreamAudioResponse?> _getCacheFile(int? start, int? end) async {
    // 读取缓存
    final cacheFile = await audioCacheManage.getFileFromCache(_cacheKey);

    if (cacheFile?.file != null) {
      if (cacheFile!.file.existsSync()) {
        var file = cacheFile.file;
        final sourceLength = file.lengthSync();
        return StreamAudioResponse(
          rangeRequestsSupported: true,
          sourceLength: sourceLength,
          contentLength: (end ?? sourceLength) - (start ?? 0),
          offset: start,
          contentType: "video/mp4",
          stream: file.openRead(start, end).asBroadcastStream(),
        );
      }
    }
    return null;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // 缓存判断
    final cacheFile = await _getCacheFile(start, end);
    if (cacheFile != null) {
      // print('缓存命中');
      return cacheFile;
    }
    await _init();
    start ??= 0;
    // print("开始长度: $start");
    // print("结束长度: $end");
    // print("bytes.length: ${_bytes.length}");
    end ??= _bytes.length;

    // 轮询 _bytes 的长度, 等待 _bytes 有足够的数据
    while (_bytes.length < end) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return StreamAudioResponse(
      sourceLength: _sourceLength,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_bytes.sublist(start, end)),
      contentType: _contentType,
      rangeRequestsSupported: true,
    );
  }
}

String music2cacheKey(MusicItem music) {
  return "${music.origin.value}-${music.id}";
}
