import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../application/playback_controller.dart';

import 'now_playing_screen.dart';

class MiniPlayer extends ConsumerWidget {
  final VoidCallback? onTap;

  const MiniPlayer({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);
    final track = state.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final isLiked = state.isTrackLiked(track.id);

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap ?? () => NowPlayingScreen.show(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      // Thumbnail
                      AppNetworkImage(
                        url: track.thumbnailUrl,
                        width: 44,
                        height: 44,
                        borderRadius: 8,
                      ),
                      const SizedBox(width: 10),

                      // Title & Artist
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              track.title,
                              style: AppTypography.titleSmall.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              track.artist,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.accentLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Heart button
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        icon: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isLiked ? AppColors.accent : AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => controller.toggleFavorite(track.id),
                      ),

                      // Previous button
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: controller.previous,
                      ),

                      // Play / Pause circular purple button
                      GestureDetector(
                        onTap: controller.togglePlayPause,
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),

                      // Next button
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: controller.next,
                      ),

                      // Queue icon
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        icon: const Icon(
                          Icons.playlist_play_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Slim purple progress line at bottom of miniplayer
            LinearProgressIndicator(
              value: state.progressFraction,
              minHeight: 2,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
