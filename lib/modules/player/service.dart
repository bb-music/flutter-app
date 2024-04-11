import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_app/modules/player/instance.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final BBPlayer player = BBPlayer();
  late PlaybackEvent _audioEvent;
  bool _playing = false;
  double get _speed => player.audio.speed;
  MusicItem? get current => player.current;

  AudioPlayerHandler() {
    Timer? timer;
    player.audio.playbackEventStream.listen((event) {
      _audioEvent = event;
    });
    player.audio.playerStateStream.listen((state) {
      timer?.cancel();
      timer = Timer(const Duration(microseconds: 100), () {
        _updateMediaItem();
        _broadcastState();
      });
    });
    _updateMediaItem();
    player.audio.positionStream.listen((position) {
      _updatePosition();
    });
    player.audio.durationStream.listen((duration) {
      if (mediaItem.value != null) {
        mediaItem.add(mediaItem.value!.copyWith(duration: duration));
      }
    });
  }
  @override
  Future<void> play({MusicItem? music}) async {
    print('播放');
    _playing = true;
    await player.play(music: music);
    _updateMediaItem();
    _updatePosition();
    _broadcastState();
  }

  @override
  Future<void> pause() async {
    print('暂停');
    _playing = false;
    await player.pause();
    _updatePosition();
    _broadcastState();
  }

  @override
  Future<void> seek(Duration position) => player.audio.seek(position);

  @override
  Future<void> skipToPrevious() async {
    print('上一首');
    await player.prev();
    _updateMediaItem();
    _broadcastState();
  }

  @override
  Future<void> skipToNext() async {
    print('下一首');
    await player.next();
    _updateMediaItem();
    _broadcastState();
  }

  void _updateMediaItem() {
    if (player.current != null) {
      final newItem = music2mediaItem(player.current!);
      mediaItem.add(newItem.copyWith(
        duration: player.audio.duration ?? newItem.duration,
      ));
    }
  }

  void _updatePosition() {
    _audioEvent = _audioEvent.copyWith(
      updatePosition: player.audio.position,
      bufferedPosition: player.audio.bufferedPosition,
      updateTime: DateTime.now(),
    );
  }

  void _broadcastState() {
    final controls = [
      MediaControl.skipToPrevious,
      if (_playing) MediaControl.pause else MediaControl.play,
      MediaControl.skipToNext,
    ];
    final processingState = const {
      // ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[player.audio.processingState];
    playbackState.add(playbackState.value.copyWith(
      controls: controls,
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices:
          List.generate(controls.length, (i) => i).toList(),
      processingState: processingState ?? AudioProcessingState.ready,
      playing: _playing,
      updatePosition: player.audio.position,
      bufferedPosition: player.audio.bufferedPosition,
      speed: _speed,
      queueIndex: _audioEvent.currentIndex,
    ));
  }
}

MediaItem music2mediaItem(MusicItem music) {
  return MediaItem(
    id: music.id,
    title: music.name,
    album: music.author,
    artist: music.author,
    duration: Duration(seconds: music.duration),
    artUri: Uri.parse(music.cover),
  );
}
