import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/playlist_model.dart';
import '../../../shared/models/track.dart';
import '../../player/application/playback_controller.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_section_header.dart';
import 'widgets/made_for_you_list.dart';
import 'widgets/recently_played_list.dart';
import 'widgets/trending_now_list.dart';

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
            HomeHeader(onProfileTap: onProfileTap),

            const SizedBox(height: 18),

            // Search Bar (Pill style)
            HomeSearchBar(onTap: onSearchTap),

            const SizedBox(height: 26),

            // Section 1: Recently Played
            HomeSectionHeader(title: 'Recently Played', onSeeAll: () {}),
            const SizedBox(height: 14),
            RecentlyPlayedList(
              playbackController: playbackController,
              onPlaylistTap: onPlaylistTap,
            ),

            const SizedBox(height: 28),

            // Section 2: Made for You
            HomeSectionHeader(title: 'Made for You', onSeeAll: () {}),
            const SizedBox(height: 14),
            MadeForYouList(
              playbackController: playbackController,
              onPlaylistTap: onPlaylistTap,
            ),

            const SizedBox(height: 28),

            // Section 3: Trending Now
            HomeSectionHeader(title: 'Trending Now', onSeeAll: () {}),
            const SizedBox(height: 12),
            TrendingNowList(
              playbackState: playbackState,
              playbackController: playbackController,
              onMoreTap: _showTrackOptions,
            ),
          ],
        ),
      ),
    );
  }

  void _showTrackOptions(PlaybackController controller, Track track) {
    // Action sheet placeholder for track options
  }
}
