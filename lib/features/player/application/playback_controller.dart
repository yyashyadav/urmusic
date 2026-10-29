import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../shared/data/mock_music_data.dart';
import '../../../shared/models/track.dart';
import '../data/audio_player_service.dart';

class PlaybackState {
  final Track? currentTrack;
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final List<Track> queue;
  final int queueIndex;
  final bool isShuffle;
  final bool isRepeat;
  final Set<String> favoriteTrackIds;

  const PlaybackState({
    this.currentTrack,
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.queue = const [],
    this.queueIndex = 0,
    this.isShuffle = false,
    this.isRepeat = false,
    this.favoriteTrackIds = const {'track_1', 'track_2', 'track_3', 'track_7'},
  });

  PlaybackState copyWith({
    Track? currentTrack,
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    Duration? bufferedPosition,
    List<Track>? queue,
    int? queueIndex,
    bool? isShuffle,
    bool? isRepeat,
    Set<String>? favoriteTrackIds,
  }) {
    return PlaybackState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      queue: queue ?? this.queue,
      queueIndex: queueIndex ?? this.queueIndex,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      favoriteTrackIds: favoriteTrackIds ?? this.favoriteTrackIds,
    );
  }

  bool isTrackLiked(String trackId) => favoriteTrackIds.contains(trackId);

  double get progressFraction {
    if (duration.inMilliseconds <= 0) return 0.0;
    final frac = position.inMilliseconds / duration.inMilliseconds;
    return frac.clamp(0.0, 1.0);
  }

  String get formattedPosition {
    final m = position.inMinutes;
    final s = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get formattedRemaining {
    final rem = duration - position;
    if (rem.isNegative) return '0:00';
    final m = rem.inMinutes;
    final s = rem.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '-$m:$s';
  }
}

class PlaybackController extends StateNotifier<PlaybackState> {
  final AudioPlayerService _audioService;

  final List<StreamSubscription> _subscriptions = [];
  int _activeRequestToken = 0;

  PlaybackController(this._audioService)
    : super(
        PlaybackState(
          currentTrack: MockMusicData.trackGoldenHour,
          isPlaying: true,
          position: const Duration(minutes: 1, seconds: 48),
          duration: const Duration(minutes: 3, seconds: 40),
          queue: [
            MockMusicData.trackGoldenHour,
            MockMusicData.trackTheJourney,
            MockMusicData.trackLateNight,
            MockMusicData.trackDieWithASmile,
            MockMusicData.trackApt,
          ],
          queueIndex: 0,
          favoriteTrackIds: const {'track_1', 'track_2', 'track_3', 'track_7'},
        ),
      ) {
    _initAudioListeners();
  }

  void _initAudioListeners() {
    _subscriptions.add(
      _audioService.positionStream.listen(
        (pos) {
          state = state.copyWith(position: pos);
        },
        onError: (_) {},
      ),
    );

    _subscriptions.add(
      _audioService.durationStream.listen(
        (dur) {
          if (dur != null && dur > Duration.zero) {
            state = state.copyWith(duration: dur);
          }
        },
        onError: (_) {},
      ),
    );

    _subscriptions.add(
      _audioService.bufferedPositionStream.listen(
        (buff) {
          state = state.copyWith(bufferedPosition: buff);
        },
        onError: (_) {},
      ),
    );

    _subscriptions.add(
      _audioService.playerStateStream.listen(
        (playerState) {
          final isBuffering =
              playerState.processingState == ProcessingState.buffering ||
              playerState.processingState == ProcessingState.loading;
          final isPlaying = playerState.playing;

          state = state.copyWith(
            isPlaying: isPlaying,
            isBuffering: isBuffering,
          );

          if (playerState.processingState == ProcessingState.completed) {
            if (state.isRepeat) {
              seek(Duration.zero);
              _audioService.play();
            } else {
              next();
            }
          }
        },
        onError: (_) {},
      ),
    );
  }

  /// Plays [track] using AudioPlayerService.playYoutubeVideo.
  Future<void> playTrack(Track track, {List<Track>? newQueue}) async {
    final queue = newQueue ?? state.queue;
    final index = queue.indexWhere((t) => t.id == track.id);
    final requestToken = ++_activeRequestToken;

    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      isBuffering: true,
      position: Duration.zero,
      duration: track.duration,
      queue: index != -1 ? queue : [track, ...queue],
      queueIndex: index != -1 ? index : 0,
    );

    // If it's a mock track from demo data, skip extraction
    if (track.id.startsWith('track_') || track.id.startsWith('mix_')) {
      state = state.copyWith(isBuffering: false);
      return;
    }

    try {
      await _audioService.playYoutubeVideo(track.id);
      if (requestToken == _activeRequestToken) {
        state = state.copyWith(isBuffering: false);
      }
    } catch (_) {
      if (requestToken == _activeRequestToken) {
        state = state.copyWith(isBuffering: false);
      }
    }
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _audioService.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      _audioService.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  void seek(Duration pos) {
    state = state.copyWith(position: pos);
    _audioService.seekTo(pos);
  }

  void seekFraction(double frac) {
    final newMs = (state.duration.inMilliseconds * frac).toInt();
    seek(Duration(milliseconds: newMs));
  }

  void next() {
    if (state.queue.isEmpty) return;
    final nextIndex = (state.queueIndex + 1) % state.queue.length;
    final nextTrack = state.queue[nextIndex];
    playTrack(nextTrack);
  }

  void previous() {
    if (state.queue.isEmpty) return;
    if (state.position.inSeconds > 3) {
      seek(Duration.zero);
      return;
    }
    final prevIndex =
        (state.queueIndex - 1 + state.queue.length) % state.queue.length;
    final prevTrack = state.queue[prevIndex];
    playTrack(prevTrack);
  }

  void toggleFavorite(String trackId) {
    final updated = Set<String>.from(state.favoriteTrackIds);
    if (updated.contains(trackId)) {
      updated.remove(trackId);
    } else {
      updated.add(trackId);
    }
    state = state.copyWith(favoriteTrackIds: updated);
  }

  void toggleShuffle() {
    state = state.copyWith(isShuffle: !state.isShuffle);
  }

  void toggleRepeat() {
    state = state.copyWith(isRepeat: !state.isRepeat);
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}

final playbackControllerProvider =
    StateNotifierProvider<PlaybackController, PlaybackState>((ref) {
      final audioService = ref.watch(audioPlayerServiceProvider);
      return PlaybackController(audioService);
    });
