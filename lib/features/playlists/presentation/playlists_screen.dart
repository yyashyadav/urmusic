import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/data/mock_music_data.dart';
import '../../../shared/models/playlist_model.dart';
import '../../player/application/playback_controller.dart';
import 'playlist_detail_screen.dart';
import 'widgets/new_playlist_banner.dart';
import 'widgets/playlists_grid.dart';

class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(playbackControllerProvider.notifier);

    // Combine recentlyPlayed + madeForYouMixes as the playlists collection
    final allPlaylists = [
      ...MockMusicData.recentlyPlayed,
      ...MockMusicData.madeForYouMixes,
      // Extra playlists to match Playlists.png grid (Golden Hour, Road Trip)
      const PlaylistModel(
        id: 'playlist_golden_hour',
        title: 'Golden Hour',
        subtitle: 'JVKE',
        artworkUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&auto=format&fit=crop&q=80',
        songCount: 12,
        tracks: [],
      ),
      const PlaylistModel(
        id: 'playlist_road_trip',
        title: 'Road Trip',
        subtitle: 'Playlist',
        artworkUrl:
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&auto=format&fit=crop&q=80',
        songCount: 35,
        tracks: [],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 130),
          children: [
            // Large title
            Text(
              'Playlists',
              style: AppTypography.headlineLarge.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 20),

            // New Playlist banner
            NewPlaylistBanner(onTap: () {}),

            const SizedBox(height: 24),

            // 3-column grid
            PlaylistsGrid(
              playlists: allPlaylists,
              onTap: (playlist) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlaylistDetailScreen(
                      playlist: playlist,
                      playbackController: controller,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
