import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/playback_controller.dart';

/// Seek slider with position and remaining time labels.
class PlayerProgressSlider extends StatefulWidget {
  final PlaybackState state;
  final PlaybackController controller;

  const PlayerProgressSlider({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  State<PlayerProgressSlider> createState() => _PlayerProgressSliderState();
}

class _PlayerProgressSliderState extends State<PlayerProgressSlider> {
  double? _dragFraction;

  @override
  Widget build(BuildContext context) {
    final currentFraction =
        _dragFraction ?? widget.state.progressFraction;

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3.5,
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.surfaceHighlight,
            thumbColor: AppColors.accentLight,
            overlayColor: AppColors.accent.withValues(alpha: 0.15),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
              elevation: 2,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            trackShape: const RectangularSliderTrackShape(),
          ),
          child: Slider(
            value: currentFraction.clamp(0.0, 1.0),
            onChanged: (val) {
              setState(() => _dragFraction = val);
            },
            onChangeEnd: (val) {
              widget.controller.seekFraction(val);
              setState(() => _dragFraction = null);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.state.formattedPosition,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.state.formattedRemaining,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
