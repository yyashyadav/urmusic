import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/playback_controller.dart';

/// Playback control row: Shuffle → Prev → Play/Pause → Next → Repeat.
class PlaybackControls extends StatelessWidget {
  final PlaybackState state;
  final PlaybackController controller;

  const PlaybackControls({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Shuffle
        IconButton(
          icon: Icon(
            Icons.shuffle_rounded,
            color: state.isShuffle
                ? AppColors.accentLight
                : AppColors.textSecondary,
            size: 24,
          ),
          onPressed: controller.toggleShuffle,
        ),

        // Skip Previous
        IconButton(
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: 38,
          ),
          onPressed: controller.previous,
        ),

        // Big Play / Pause button
        GestureDetector(
          onTap: controller.togglePlayPause,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),

        // Skip Next
        IconButton(
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
            size: 38,
          ),
          onPressed: controller.next,
        ),

        // Repeat
        IconButton(
          icon: Icon(
            Icons.repeat_rounded,
            color: state.isRepeat
                ? AppColors.accentLight
                : AppColors.textSecondary,
            size: 24,
          ),
          onPressed: controller.toggleRepeat,
        ),
      ],
    );
  }
}
