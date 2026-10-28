import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../shared/models/playlist_model.dart';

/// 3-column grid of playlist cards with play overlay, matching Playlists.png.
class PlaylistsGrid extends StatelessWidget {
  final List<PlaylistModel> playlists;
  final void Function(PlaylistModel)? onTap;

  const PlaylistsGrid({
    super.key,
    required this.playlists,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlists.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return GestureDetector(
          onTap: () => onTap?.call(playlist),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Artwork with play overlay
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox.expand(
                        child: _buildArtwork(playlist),
                      ),
                    ),
                    // Play icon badge at bottom-right
                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                playlist.title,
                style: AppTypography.titleSmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                playlist.subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtwork(PlaylistModel playlist) {
    if (playlist.artworkUrl.isNotEmpty) {
      return AppNetworkImage(
        url: playlist.artworkUrl,
        width: double.infinity,
        height: double.infinity,
        borderRadius: 12,
      );
    }
    // Gradient block for mixes
    return Container(
      decoration: BoxDecoration(
        gradient: playlist.gradient,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
