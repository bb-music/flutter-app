import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';

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

  static Future<StreamedResponse> getMusicStream(
    MusicItem music,
    Function(List<int> data) callback,
  ) {
    final completer = Completer<StreamedResponse>();

    service.getMusicUrl(music.id).then((musicUrl) {
      var request = Request('GET', Uri.parse(musicUrl.url));
      request.headers.addAll(musicUrl.headers ?? {});
      Client client = Client();
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

  BBMusicSource(this.music);

  _init() async {
    if (_isInit) return;
    var resp = await BBMusicSource.getMusicStream(music, (List<int> data) {
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
