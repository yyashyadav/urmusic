import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/browse_all_grid.dart';
import 'widgets/recent_searches_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
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
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 30),

            // Recent Searches section
            Text(
              'Recent searches',
              style: AppTypography.titleLarge.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            RecentSearchesList(items: _recentSearches),

            const SizedBox(height: 28),

            // Browse All section
            Text(
              'Browse all',
              style: AppTypography.titleLarge.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            BrowseAllGrid(categories: _categories),
          ],
        ),
      ),
    );
  }
}
