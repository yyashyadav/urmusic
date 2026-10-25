import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Top bar for the Now Playing screen: back arrow, "NOW PLAYING" label, cast & more icons.
class NowPlayingTopBar extends StatelessWidget {
  const NowPlayingTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(
          'NOW PLAYING',
          style: AppTypography.labelSmall.copyWith(
            letterSpacing: 2.5,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.cast_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
