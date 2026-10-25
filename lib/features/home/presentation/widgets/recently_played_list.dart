import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../shared/data/mock_music_data.dart';
import '../../../../shared/models/playlist_model.dart';
import '../../../player/application/playback_controller.dart';

/// Horizontally scrollable list of recently played playlist cards.
class RecentlyPlayedList extends StatelessWidget {
  final PlaybackController playbackController;
  final void Function(PlaylistModel playlist)? onPlaylistTap;

  const RecentlyPlayedList({
    super.key,
    required this.playbackController,
    this.onPlaylistTap,
  });

  @override
  Widget build(BuildContext context) {
    final playlists = MockMusicData.recentlyPlayed;

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return GestureDetector(
            onTap: () {
              if (onPlaylistTap != null) {
                onPlaylistTap!(playlist);
              } else if (playlist.tracks.isNotEmpty) {
                playbackController.playTrack(
                  playlist.tracks.first,
                  newQueue: playlist.tracks,
                );
              }
            },
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artwork with play badge overlay
                  Stack(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AppNetworkImage(
                          url: playlist.artworkUrl,
                          width: 140,
                          height: 140,
                          borderRadius: 16,
                        ),
                      ),
                      // Play icon badge at bottom right
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    playlist.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    playlist.subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
