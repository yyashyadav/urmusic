import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/mock_music_data.dart';
import '../../../shared/models/track.dart';

class PlaybackState {
  final Track? currentTrack;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final List<Track> queue;
  final int queueIndex;
  final bool isShuffle;
  final bool isRepeat;
  final Set<String> favoriteTrackIds;

  const PlaybackState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = const Duration(minutes: 1, seconds: 48),
    this.duration = const Duration(minutes: 3, seconds: 40),
    this.queue = const [],
    this.queueIndex = 0,
    this.isShuffle = false,
    this.isRepeat = false,
    this.favoriteTrackIds = const {'track_1', 'track_2', 'track_3', 'track_7'},
  });

  PlaybackState copyWith({
    Track? currentTrack,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    List<Track>? queue,
    int? queueIndex,
    bool? isShuffle,
    bool? isRepeat,
    Set<String>? favoriteTrackIds,
  }) {
    return PlaybackState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      queue: queue ?? this.queue,
      queueIndex: queueIndex ?? this.queueIndex,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      favoriteTrackIds: favoriteTrackIds ?? this.favoriteTrackIds,
    );
  }

  bool isTrackLiked(String trackId) => favoriteTrackIds.contains(trackId);

  double get progressFraction {
    if (duration.inMilliseconds == 0) return 0.0;
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
  PlaybackController()
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
      );

  void playTrack(Track track, {List<Track>? newQueue}) {
    final queue = newQueue ?? state.queue;
    final index = queue.indexWhere((t) => t.id == track.id);

    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      position: Duration.zero,
      duration: track.duration,
      queue: index != -1 ? queue : [track, ...queue],
      queueIndex: index != -1 ? index : 0,
    );
  }

  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void seek(Duration pos) {
    state = state.copyWith(position: pos);
  }

  void seekFraction(double frac) {
    final newMs = (state.duration.inMilliseconds * frac).toInt();
    seek(Duration(milliseconds: newMs));
  }

  void next() {
    if (state.queue.isEmpty) return;
    final nextIndex = (state.queueIndex + 1) % state.queue.length;
    final nextTrack = state.queue[nextIndex];
    state = state.copyWith(
      currentTrack: nextTrack,
      queueIndex: nextIndex,
      position: Duration.zero,
      duration: nextTrack.duration,
      isPlaying: true,
    );
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
    state = state.copyWith(
      currentTrack: prevTrack,
      queueIndex: prevIndex,
      position: Duration.zero,
      duration: prevTrack.duration,
      isPlaying: true,
    );
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
}

final playbackControllerProvider =
    StateNotifierProvider<PlaybackController, PlaybackState>((ref) {
      return PlaybackController();
    });
