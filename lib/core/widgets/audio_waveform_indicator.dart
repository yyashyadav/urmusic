import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AudioWaveformIndicator extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final double height;

  const AudioWaveformIndicator({
    super.key,
    this.isPlaying = true,
    this.color = AppColors.accent,
    this.height = 16,
  });

  @override
  State<AudioWaveformIndicator> createState() => _AudioWaveformIndicatorState();
}

class _AudioWaveformIndicatorState extends State<AudioWaveformIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AudioWaveformIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = _controller.value;
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(widget.height * (0.3 + 0.6 * val)),
              const SizedBox(width: 2.5),
              _buildBar(widget.height * (0.8 - 0.5 * val)),
              const SizedBox(width: 2.5),
              _buildBar(widget.height * (0.4 + 0.55 * (1 - val))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBar(double h) {
    return Container(
      width: 2.5,
      height: h.clamp(3.0, widget.height),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
