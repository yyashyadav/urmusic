import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yt_extractor/yt_extractor.dart';

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(() => service.dispose());
  return service;
});

class AudioPlayerService {
  final AudioPlayer _player;
  final YtExtractor _extractor;

  AudioPlayerService({AudioPlayer? player, YtExtractor? extractor})
      : _player = player ?? AudioPlayer(),
        _extractor = extractor ?? YtExtractor();

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;

  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;

  Future<void> playYoutubeVideo(String videoId) async {
    // Stop the current song immediately.
    await _player.stop();

    await _extractor.init();

    final videoUrl = videoId.startsWith('http')
        ? videoId
        : 'https://www.youtube.com/watch?v=$videoId';

    final info = await _extractor.getStreamInfo(videoUrl);
    final audioStream = info.audioStreams.cast<AudioStream?>().firstWhere(
      (s) =>
          s != null &&
          (s.format?.toLowerCase() == 'm4a' ||
              s.codec?.toLowerCase().contains('mp4') == true),
      orElse: () =>
          info.bestAudioStream ??
          (info.audioStreams.isNotEmpty ? info.audioStreams.first : null),
    );

    if (audioStream == null) {
      throw Exception('No audio stream available for this video.');
    }

    // Replace the previous song and start playback immediately
    await _player.setUrl(audioStream.url);
    _player.play();
  }

  Future<void> loadAudio(String url) async {
    await _player.setUrl(url);
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seekForward() async {
    final currentPosition = _player.position;
    final dur = _player.duration;
    final target = currentPosition + const Duration(seconds: 10);

    if (dur != null && target > dur) {
      await _player.seek(dur);
    } else {
      await _player.seek(target);
    }
  }

  Future<void> seekBackward() async {
    final target = _player.position - const Duration(seconds: 10);
    await _player.seek(target < Duration.zero ? Duration.zero : target);
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
