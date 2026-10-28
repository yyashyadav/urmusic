import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/library_filter_chips.dart';
import 'widgets/library_item_list.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedFilter = 0;

  final List<String> _filters = ['Playlists', 'Albums', 'Artists', 'Podcasts'];

  // Mock data matching Your Library.png
  final List<LibraryItem> _items = [
    const LibraryItem(
      title: 'Liked Songs',
      subtitle: 'Playlist · 324 songs',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=200&auto=format&fit=crop&q=80',
    ),
    const LibraryItem(
      title: 'Chill Vibes',
      subtitle: 'Playlist · 50 songs',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=200&auto=format&fit=crop&q=80',
    ),
    const LibraryItem(
      title: 'The Journey',
      subtitle: 'Playlist · 86 songs',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=200&auto=format&fit=crop&q=80',
    ),
    const LibraryItem(
      title: 'Late Night',
      subtitle: 'Playlist · 72 songs',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=200&auto=format&fit=crop&q=80',
    ),
    LibraryItem(
      title: 'Daily Mix 1',
      subtitle: 'Made for you',
      gradient: LinearGradient(
        colors: [AppColors.accentDark, AppColors.accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    LibraryItem(
      title: 'Chill Mix',
      subtitle: 'Made for you',
      gradient: const LinearGradient(
        colors: [Color(0xFF059669), Color(0xFF34D399)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    LibraryItem(
      title: 'Focus Mix',
      subtitle: 'Made for you',
      gradient: const LinearGradient(
        colors: [Color(0xFFE8614A), Color(0xFFF4A261)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    const LibraryItem(
      title: 'Golden Hour',
      subtitle: 'Song · JVKE',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200&auto=format&fit=crop&q=80',
    ),
    const LibraryItem(
      title: 'Die With A Smile',
      subtitle: 'Song · Lady Gaga, Bruno Mars',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=200&auto=format&fit=crop&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 130),
          children: [
            // Large title
            Text(
              'Your Library',
              style: AppTypography.headlineLarge.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 18),

            // Filter chip tabs
            LibraryFilterChips(
              filters: _filters,
              selectedIndex: _selectedFilter,
              onSelect: (i) => setState(() => _selectedFilter = i),
            ),

            const SizedBox(height: 24),

            // "Recently played" subheader
            Text(
              'Recently played',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // List of library items
            LibraryItemList(items: _items),
          ],
        ),
      ),
    );
  }
}
