import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/audio_waveform_indicator.dart';
import '../../../shared/models/playlist_model.dart';
import '../../../shared/models/track.dart';
import '../../player/application/playback_controller.dart';
import '../../player/presentation/now_playing_screen.dart';

/// Full-page playlist detail screen matching Playlist.png.
class PlaylistDetailScreen extends ConsumerWidget {
  final PlaylistModel playlist;
  final PlaybackController playbackController;

  const PlaylistDetailScreen({
    super.key,
    required this.playlist,
    required this.playbackController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackControllerProvider);
    final controller = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Transparent app bar with back + more
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded,
                    color: Colors.white, size: 22),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artwork
                  Center(
                    child: _buildArtwork(),
                  ),

                  const SizedBox(height: 20),

                  // Title + subtitle
                  Text(
                    playlist.title,
                    style: AppTypography.headlineLarge.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    playlist.subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Actions row: heart + download + shuffle + BIG play
                  _buildActionsRow(controller, state),

                  const SizedBox(height: 20),

                  // Track list
                  if (playlist.tracks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No songs in this playlist',
                          style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...playlist.tracks.asMap().entries.map((entry) {
                      final track = entry.value;
                      return _buildTrackRow(context, track, state, controller);
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork() {
    if (playlist.artworkUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AppNetworkImage(
          url: playlist.artworkUrl,
          width: 240,
          height: 240,
          borderRadius: 18,
        ),
      );
    }
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        gradient: playlist.gradient,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildActionsRow(PlaybackController controller, PlaybackState state) {
    return Row(
      children: [
        // Heart
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded,
              color: AppColors.textSecondary, size: 26),
          onPressed: () {},
        ),
        // Download
        IconButton(
          icon: const Icon(Icons.download_outlined,
              color: AppColors.textSecondary, size: 26),
          onPressed: () {},
        ),
        // Shuffle
        IconButton(
          icon: const Icon(Icons.shuffle_rounded,
              color: AppColors.textSecondary, size: 26),
          onPressed: () {},
        ),

        const Spacer(),

        // Big purple play button (matches Playlist.png)
        GestureDetector(
          onTap: () {
            if (playlist.tracks.isNotEmpty) {
              controller.playTrack(
                playlist.tracks.first,
                newQueue: playlist.tracks,
              );
            }
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackRow(
    BuildContext context,
    Track track,
    PlaybackState state,
    PlaybackController controller,
  ) {
    final isCurrentTrack = state.currentTrack?.id == track.id;
    final isPlaying = isCurrentTrack && state.isPlaying;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          controller.playTrack(track, newQueue: playlist.tracks);
          NowPlayingScreen.show(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Row(
            children: [
              // Thumbnail
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

              // Title + artist
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
                      track.artist,
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

              // Waveform when playing
              if (isPlaying) ...[
                const AudioWaveformIndicator(height: 16),
                const SizedBox(width: 8),
              ],

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
        ),
      ),
    );
  }
}
