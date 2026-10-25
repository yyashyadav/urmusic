import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/audio_waveform_indicator.dart';
import '../../../../shared/data/mock_music_data.dart';
import '../../../../shared/models/track.dart';
import '../../../player/application/playback_controller.dart';

/// Vertical list of trending tracks with waveform indicator for active track.
class TrendingNowList extends StatelessWidget {
  final PlaybackState playbackState;
  final PlaybackController playbackController;
  final void Function(PlaybackController controller, Track track)? onMoreTap;

  const TrendingNowList({
    super.key,
    required this.playbackState,
    required this.playbackController,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final tracks = MockMusicData.trendingNow;

    return Column(
      children: tracks.map((track) {
        final isCurrentTrack = playbackState.currentTrack?.id == track.id;
        final isPlaying = isCurrentTrack && playbackState.isPlaying;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => playbackController.playTrack(track, newQueue: tracks),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  // Track Thumbnail
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppNetworkImage(
                      url: track.thumbnailUrl,
                      width: 52,
                      height: 52,
                      borderRadius: 8,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Song Title & Artist
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          style: AppTypography.titleSmall.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isCurrentTrack
                                ? AppColors.accentLight
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          track.artist,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Audio waveform (only when playing)
                  if (isPlaying) ...[
                    const AudioWaveformIndicator(height: 16),
                    const SizedBox(width: 12),
                  ],

                  // More options (3-dots)
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => onMoreTap?.call(playbackController, track),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
