import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../shared/data/mock_music_data.dart';
import '../../../../shared/models/playlist_model.dart';
import '../../../player/application/playback_controller.dart';

/// Horizontally scrollable list of "Made for You" gradient mix cards.
class MadeForYouList extends StatelessWidget {
  final PlaybackController playbackController;
  final void Function(PlaylistModel playlist)? onPlaylistTap;

  const MadeForYouList({
    super.key,
    required this.playbackController,
    this.onPlaylistTap,
  });

  @override
  Widget build(BuildContext context) {
    final mixes = MockMusicData.madeForYouMixes;

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: mixes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final mix = mixes[index];
          return GestureDetector(
            onTap: () {
              if (onPlaylistTap != null) {
                onPlaylistTap!(mix);
              } else if (mix.tracks.isNotEmpty) {
                playbackController.playTrack(
                  mix.tracks.first,
                  newQueue: mix.tracks,
                );
              }
            },
            child: Container(
              width: 148,
              height: 180,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: mix.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (mix.gradient?.colors.first ?? Colors.black)
                        .withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Title & Subtitle at bottom left
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mix.title,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mix.subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // White circular play button at bottom right
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
