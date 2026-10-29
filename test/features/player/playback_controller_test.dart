import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:urmusic/features/player/application/playback_controller.dart';
import 'package:urmusic/features/player/data/audio_player_service.dart';
import 'package:urmusic/shared/models/track.dart';

class FakeAudioPlayerService implements AudioPlayerService {
  final _posController = StreamController<Duration>.broadcast();
  final _durController = StreamController<Duration?>.broadcast();
  final _buffController = StreamController<Duration>.broadcast();
  final _stateController = StreamController<PlayerState>.broadcast();
  final _procController = StreamController<ProcessingState>.broadcast();

  bool didCallPlay = false;
  bool didCallPause = false;
  String? playedVideoId;
  Duration? seekTarget;

  @override
  AudioPlayer get player => throw UnimplementedError();

  @override
  Stream<Duration> get positionStream => _posController.stream;
  @override
  Stream<Duration?> get durationStream => _durController.stream;
  @override
  Stream<Duration> get bufferedPositionStream => _buffController.stream;
  @override
  Stream<PlayerState> get playerStateStream => _stateController.stream;
  @override
  Stream<ProcessingState> get processingStateStream => _procController.stream;

  @override
  bool get isPlaying => didCallPlay && !didCallPause;
  @override
  Duration get position => Duration.zero;
  @override
  Duration? get duration => null;

  @override
  Future<void> playYoutubeVideo(String videoId) async {
    playedVideoId = videoId;
    didCallPlay = true;
    didCallPause = false;
  }

  @override
  Future<void> loadAudio(String url) async {}

  @override
  Future<void> play() async {
    didCallPlay = true;
    didCallPause = false;
  }

  @override
  Future<void> pause() async {
    didCallPause = true;
  }

  @override
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  @override
  Future<void> seekForward() async {}

  @override
  Future<void> seekBackward() async {}

  @override
  Future<void> seekTo(Duration position) async {
    seekTarget = position;
  }

  @override
  Future<void> setVolume(double volume) async {}

  void emitPosition(Duration pos) => _posController.add(pos);
  void emitDuration(Duration? dur) => _durController.add(dur);

  @override
  Future<void> dispose() async {
    await _posController.close();
    await _durController.close();
    await _buffController.close();
    await _stateController.close();
    await _procController.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlaybackController tests', () {
    late FakeAudioPlayerService fakePlayer;
    late PlaybackController controller;

    setUp(() {
      fakePlayer = FakeAudioPlayerService();
      controller = PlaybackController(fakePlayer);
    });

    tearDown(() {
      controller.dispose();
      fakePlayer.dispose();
    });

    test('Initial state has track and is playing', () {
      expect(controller.state.currentTrack, isNotNull);
      expect(controller.state.queue, isNotEmpty);
    });

    test('playTrack triggers playerService.playYoutubeVideo with videoId', () async {
      const track = Track(
        id: 'real_yt_id',
        title: 'New Track',
        artist: 'Artist',
        duration: Duration(minutes: 4),
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );

      await controller.playTrack(track);

      expect(controller.state.currentTrack?.id, 'real_yt_id');
      expect(fakePlayer.playedVideoId, 'real_yt_id');
      expect(fakePlayer.didCallPlay, isTrue);
    });

    test('togglePlayPause toggles state and calls player pause/play', () {
      expect(controller.state.isPlaying, isTrue);

      controller.togglePlayPause();
      expect(controller.state.isPlaying, isFalse);
      expect(fakePlayer.didCallPause, isTrue);

      controller.togglePlayPause();
      expect(controller.state.isPlaying, isTrue);
      expect(fakePlayer.didCallPlay, isTrue);
    });

    test('seek updates position and calls player seekTo', () {
      controller.seek(const Duration(seconds: 45));
      expect(controller.state.position.inSeconds, 45);
      expect(fakePlayer.seekTarget?.inSeconds, 45);
    });

    test('Player position stream updates controller state', () async {
      fakePlayer.emitPosition(const Duration(seconds: 12));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(controller.state.position.inSeconds, 12);
    });

    test('toggleFavorite adds and removes track from favorites', () {
      const id = 'custom_id';
      expect(controller.state.isTrackLiked(id), isFalse);

      controller.toggleFavorite(id);
      expect(controller.state.isTrackLiked(id), isTrue);

      controller.toggleFavorite(id);
      expect(controller.state.isTrackLiked(id), isFalse);
    });
  });
}
