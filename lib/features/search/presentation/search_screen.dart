import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../player/application/playback_controller.dart';
import '../../player/presentation/now_playing_screen.dart';
import '../application/search_controller.dart' as app_search;
import 'widgets/browse_all_grid.dart';
import 'widgets/recent_searches_list.dart';
import 'widgets/search_results_list.dart';
import 'widgets/search_shimmer_skeleton.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  // Mock data matching Search.png
  final List<RecentSearchItem> _recentSearches = const [
    RecentSearchItem(
      title: 'Die With A Smile',
      subtitle: 'Song · Lady Gaga, Bruno Mars',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=200&auto=format&fit=crop&q=80',
    ),
    RecentSearchItem(
      title: 'APT.',
      subtitle: 'Song · ROSÉ, Bruno Mars',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=200&auto=format&fit=crop&q=80',
    ),
    RecentSearchItem(
      title: 'Birds Of A Feather',
      subtitle: 'Song · Billie Eilish',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=200&auto=format&fit=crop&q=80',
    ),
  ];

  final List<BrowseCategory> _categories = const [
    BrowseCategory(
      label: 'Pop',
      gradientColors: [Color(0xFFE8614A), Color(0xFFF4A261)],
    ),
    BrowseCategory(
      label: 'Hip-Hop',
      gradientColors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    ),
    BrowseCategory(
      label: 'Chill',
      gradientColors: [Color(0xFF059669), Color(0xFF34D399)],
    ),
    BrowseCategory(
      label: 'Focus',
      gradientColors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
    ),
    BrowseCategory(
      label: 'Workout',
      gradientColors: [Color(0xFFDC2626), Color(0xFFF97316)],
    ),
    BrowseCategory(
      label: 'Party',
      gradientColors: [Color(0xFF7C3AED), Color(0xFFC026D3)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(app_search.searchControllerProvider.notifier).onQueryChanged(value);
  }

  void _onCategoryTapped(String genre) {
    _controller.text = genre;
    ref.read(app_search.searchControllerProvider.notifier).executeSearch(genre);
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(app_search.searchControllerProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(app_search.searchControllerProvider);
    final playbackState = ref.watch(playbackControllerProvider);
    final playbackController = ref.read(playbackControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 130),
          children: [
            // Large "Search" title (matches Search.png)
            Text(
              'Search',
              style: AppTypography.headlineLarge.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 18),

            // Search input field
            TextField(
              controller: _controller,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Search songs, artists, playlists...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: AppColors.searchField,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide:
                      const BorderSide(color: AppColors.searchBorder, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide:
                      const BorderSide(color: AppColors.searchBorder, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref
                      .read(app_search.searchControllerProvider.notifier)
                      .executeSearch(val);
                }
              },
            ),

            const SizedBox(height: 24),

            // Dynamic Search Content based on SearchStatus
            if (searchState.status == app_search.SearchStatus.loading) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Searching for "${searchState.query}"...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SearchShimmerSkeleton(),
            ] else if (searchState.status == app_search.SearchStatus.success) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results for "${searchState.query}"',
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${searchState.results.length} tracks',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SearchResultsList(
                tracks: searchState.results,
                currentTrackId: playbackState.currentTrack?.id,
                isPlaying: playbackState.isPlaying,
                onTrackTap: (track) {
                  playbackController.playTrack(
                    track,
                    newQueue: searchState.results,
                  );
                  NowPlayingScreen.show(context);
                },
              ),
            ] else if (searchState.status == app_search.SearchStatus.empty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        color: AppColors.textMuted,
                        size: 52,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'No results found for "${searchState.query}"',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try searching by song title, artist, or album',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (searchState.status == app_search.SearchStatus.error) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        color: AppColors.accentLight,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        searchState.errorMessage ?? 'Search error occurred',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(app_search.searchControllerProvider.notifier)
                              .executeSearch(searchState.query);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Idle state: Recent Searches + Browse All (matches Search.png)
              Text(
                'Recent searches',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              RecentSearchesList(
                items: _recentSearches,
                onItemTap: (item) => _onCategoryTapped(item.title),
              ),

              const SizedBox(height: 28),

              Text(
                'Browse all',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              BrowseAllGrid(
                categories: _categories,
                onCategoryTap: (cat) => _onCategoryTapped(cat.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
