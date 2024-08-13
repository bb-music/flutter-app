import 'dart:async';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';

final audioCacheManage = CacheManager(Config("bbmusicMediaCache"));

class BBMusicSource extends StreamAudioSource {
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

  Future<StreamedResponse> getMusicStream(
    MusicItem music,
    Function(List<int> data) callback,
  ) async {
    final completer = Completer<StreamedResponse>();
    // 缓存判断
    final cacheKey = music2cacheKey(music);
    final cacheFile = await audioCacheManage.getFileFromCache(cacheKey);
    if (cacheFile?.file != null) {
      var file = cacheFile!.file;
      var stream = file.openRead();
      final List<int> bytes = [];
      await for (var data in stream) {
        bytes.addAll(data);
      }
      callback(bytes);
      var contentLength = file.lengthSync();
      completer.complete(
          StreamedResponse(stream, 200, contentLength: contentLength, headers: {
        "content-type": "video/mp4",
        "content-length": contentLength.toString(),
      }));
      print("使用缓存");
      return completer.future;
    }

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
          var bytes = Uint8List.fromList(this._bytes);
          var ext = musicUrl.url.split('?').first.split('.').last;
          await audioCacheManage.putFile(
            musicUrl.url,
            bytes,
            key: cacheKey,
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
    var resp = await getMusicStream(music, (List<int> data) {
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
    // 轮询 _bytes 的长度, 等待 _bytes 有足够的数据
    while (_bytes.length < start) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
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

music2cacheKey(MusicItem music) {
  return "${music.origin.value}-${music.id}";
}
