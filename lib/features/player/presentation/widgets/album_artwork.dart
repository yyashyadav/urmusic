import 'package:flutter/material.dart';

import '../../../../core/widgets/app_network_image.dart';
import '../../../../shared/models/track.dart';

/// Large rounded album artwork for the Now Playing screen.
class AlbumArtwork extends StatelessWidget {
  final Track track;

  const AlbumArtwork({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth * 0.9).clamp(240.0, 330.0);

        return Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: AppNetworkImage(
                url: track.thumbnailUrl,
                width: size,
                height: size,
                borderRadius: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}
