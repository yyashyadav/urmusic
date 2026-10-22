import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search', style: AppTypography.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
        children: [
          // Clean iOS-like subtle search text field
          TextField(
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search songs, albums, or YouTube Mixes...',
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
              filled: true,
              fillColor: AppColors.surfaceElevated,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.glassBorder, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.glassBorder, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accent, width: 1),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text('Top Genres & Moods', style: AppTypography.titleMedium),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('YouTube Mixes'),
              _buildCategoryChip('Pop'),
              _buildCategoryChip('Lo-Fi'),
              _buildCategoryChip('Bollywood'),
              _buildCategoryChip('Punjabi'),
              _buildCategoryChip('Electronic'),
              _buildCategoryChip('Hip Hop'),
              _buildCategoryChip('Rock'),
              _buildCategoryChip('Acoustic'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return ActionChip(
      label: Text(label),
      labelStyle: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {},
    );
  }
}
