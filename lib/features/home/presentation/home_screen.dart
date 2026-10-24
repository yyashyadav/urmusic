import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/audio_waveform_indicator.dart';
import '../../../shared/data/mock_music_data.dart';
import '../../../shared/models/playlist_model.dart';
import '../../../shared/models/track.dart';
import '../../player/application/playback_controller.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final void Function(PlaylistModel playlist)? onPlaylistTap;

  const HomeScreen({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
    this.onPlaylistTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackState = ref.watch(playbackControllerProvider);
    final playbackController = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
          children: [
            // Top Header: Greeting & Profile Avatar
            _buildHeader(context),

            const SizedBox(height: 18),

            // Search Bar (Pill style matching Home.png)
            _buildSearchBar(),

            const SizedBox(height: 26),

            // Section 1: Recently Played
            _buildSectionHeader(title: 'Recently Played', onSeeAll: () {}),
            const SizedBox(height: 14),
            _buildRecentlyPlayedList(playbackController),

            const SizedBox(height: 28),

            // Section 2: Made for You
            _buildSectionHeader(title: 'Made for You', onSeeAll: () {}),
            const SizedBox(height: 14),
            _buildMadeForYouList(playbackController),

            const SizedBox(height: 28),

            // Section 3: Trending Now
            _buildSectionHeader(title: 'Trending Now', onSeeAll: () {}),
            const SizedBox(height: 12),
            _buildTrendingNowList(playbackState, playbackController),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Yash 👋',
              style: AppTypography.headlineLarge.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder, width: 1.5),
            ),
            child: ClipOval(
              child: AppNetworkImage(
                url: MockMusicData.avatarUrl,
                width: 48,
                height: 48,
                borderRadius: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.searchField,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.searchBorder, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search songs, artists, playlists...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See all',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedList(PlaybackController playbackController) {
    final playlists = MockMusicData.recentlyPlayed;

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return GestureDetector(
            onTap: () {
              if (onPlaylistTap != null) {
                onPlaylistTap!(playlist);
              } else if (playlist.tracks.isNotEmpty) {
                playbackController.playTrack(
                  playlist.tracks.first,
                  newQueue: playlist.tracks,
                );
              }
            },
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Artwork Card with subtle shadow & play button overlay
                  Stack(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AppNetworkImage(
                          url: playlist.artworkUrl,
                          width: 140,
                          height: 140,
                          borderRadius: 16,
                        ),
                      ),
                      // Play icon badge at bottom right
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    playlist.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    playlist.subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMadeForYouList(PlaybackController playbackController) {
    final mixes = MockMusicData.madeForYouMixes;

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: mixes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final mix = mixes[index];
          return GestureDetector(
            onTap: () {
              if (onPlaylistTap != null) {
                onPlaylistTap!(mix);
              } else if (mix.tracks.isNotEmpty) {
                playbackController.playTrack(
                  mix.tracks.first,
                  newQueue: mix.tracks,
                );
              }
            },
            child: Container(
              width: 148,
              height: 180,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: mix.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (mix.gradient?.colors.first ?? Colors.black)
                        .withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Title & Subtitle at bottom left
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mix.title,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mix.subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // White circular play button at bottom right
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingNowList(
    PlaybackState playbackState,
    PlaybackController playbackController,
  ) {
    final tracks = MockMusicData.trendingNow;

    return Column(
      children: tracks.map((track) {
        final isCurrentTrack = playbackState.currentTrack?.id == track.id;
        final isPlaying = isCurrentTrack && playbackState.isPlaying;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              playbackController.playTrack(track, newQueue: tracks);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  // Track Thumbnail
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppNetworkImage(
                      url: track.thumbnailUrl,
                      width: 52,
                      height: 52,
                      borderRadius: 8,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Song Title & Artist
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

                  // Audio Waveform Indicator (if playing)
                  if (isPlaying) ...[
                    const AudioWaveformIndicator(height: 16),
                    const SizedBox(width: 12),
                  ],

                  // More options 3-dots
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      _showTrackOptions(playbackController, track);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showTrackOptions(PlaybackController controller, Track track) {
    // Action sheet placeholder for track options
  }
}
