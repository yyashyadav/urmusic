import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Data model for a library list item.
class LibraryItem {
  final String title;
  final String subtitle;
  final String? thumbnailUrl;
  final LinearGradient? gradient;

  const LibraryItem({
    required this.title,
    required this.subtitle,
    this.thumbnailUrl,
    this.gradient,
  });
}

/// Vertical list of library items with thumbnail/gradient + title + subtitle + more.
class LibraryItemList extends StatelessWidget {
  final List<LibraryItem> items;

  const LibraryItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // Artwork: thumbnail OR gradient block
              _buildArtwork(item),
              const SizedBox(width: 14),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
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

              // More options
              IconButton(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildArtwork(LibraryItem item) {
    if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AppNetworkImage(
              url: item.thumbnailUrl!,
              width: 56,
              height: 56,
              borderRadius: 8,
            ),
          ),
          // Small play overlay badge (matching Your Library.png)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
            ),
          ),
        ],
      );
    }

    // Gradient block for mixes
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: item.gradient,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
