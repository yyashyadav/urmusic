import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../application/playback_controller.dart';
import 'widgets/album_artwork.dart';
import 'widgets/now_playing_top_bar.dart';
import 'widgets/playback_controls.dart';
import 'widgets/player_progress_slider.dart';
import 'widgets/song_info_row.dart';
import 'widgets/up_next_section.dart';

class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const NowPlayingScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);
    final track = state.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final isLiked = state.isTrackLiked(track.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // 1. Top Bar
              const NowPlayingTopBar(),

              const Spacer(flex: 1),

              // 2. Large Album Artwork
              AlbumArtwork(track: track),

              const Spacer(flex: 2),

              // 3. Song Info & Heart
              SongInfoRow(
                track: track,
                isLiked: isLiked,
                controller: controller,
              ),

              const SizedBox(height: 18),

              // 4. Seek Slider & Time Labels
              PlayerProgressSlider(state: state, controller: controller),

              const SizedBox(height: 18),

              // 5. Playback Controls (Shuffle / Prev / Play / Next / Repeat)
              PlaybackControls(state: state, controller: controller),

              const Spacer(flex: 2),

              // 6. Up Next Queue Card
              UpNextSection(state: state, controller: controller),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
