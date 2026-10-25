import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/track.dart';
import '../../application/playback_controller.dart';

/// Song title, artist name, and favourite heart button row.
class SongInfoRow extends StatelessWidget {
  final Track track;
  final bool isLiked;
  final PlaybackController controller;

  const SongInfoRow({
    super.key,
    required this.track,
    required this.isLiked,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                track.title,
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                track.artist,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.accentLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isLiked ? AppColors.accent : AppColors.textSecondary,
            size: 26,
          ),
          onPressed: () => controller.toggleFavorite(track.id),
        ),
      ],
    );
  }
}
