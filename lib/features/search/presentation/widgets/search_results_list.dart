import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/audio_waveform_indicator.dart';
import '../../../../shared/models/track.dart';

/// Renders search results matching the Obsidian Dark aesthetic with live audio indicators.
class SearchResultsList extends StatelessWidget {
  final List<Track> tracks;
  final String? currentTrackId;
  final bool isPlaying;
  final ValueChanged<Track> onTrackTap;
  final ValueChanged<Track>? onMoreTap;

  const SearchResultsList({
    super.key,
    required this.tracks,
    this.currentTrackId,
    this.isPlaying = false,
    required this.onTrackTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        final isCurrentTrack = currentTrackId == track.id;
        final isCurrentlyPlaying = isCurrentTrack && isPlaying;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onTrackTap(track),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  // Track Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppNetworkImage(
                      url: track.thumbnailUrl,
                      width: 52,
                      height: 52,
                      borderRadius: 8,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title + Artist + Duration
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
                          track.duration != Duration.zero
                              ? '${track.artist} • ${track.formattedDuration}'
                              : track.artist,
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

                  // Waveform indicator when actively playing
                  if (isCurrentlyPlaying) ...[
                    const AudioWaveformIndicator(height: 16),
                    const SizedBox(width: 8),
                  ],

                  // More context options
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => onMoreTap?.call(track),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
