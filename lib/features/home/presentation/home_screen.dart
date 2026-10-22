import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('urmusic', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 130),
        children: [
          // Section: YouTube Mixes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('YouTube Mixes', style: AppTypography.titleMedium),
                Text(
                  'View all',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMixItem('Weekend Mix', 'The Weeknd, Daft Punk'),
                _buildMixItem('Pop Chill Mix', 'Taylor Swift, Ed Sheeran'),
                _buildMixItem('Lo-Fi Beats Radio', 'ChillHop, Lofi Girl'),
                _buildMixItem('Electronic Mix', 'Avicii, Martin Garrix'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section: Quick Picks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Suggested Songs', style: AppTypography.titleMedium),
          ),
          _buildTrackTile('Starboy', 'The Weeknd ft. Daft Punk', '3:50'),
          _buildTrackTile('Blinding Lights', 'The Weeknd', '3:20'),
          _buildTrackTile('Midnight City', 'M83', '4:03'),
          _buildTrackTile('After Hours', 'The Weeknd', '6:01'),
          _buildTrackTile('Save Your Tears', 'The Weeknd', '3:35'),
        ],
      ),
    );
  }

  Widget _buildMixItem(String title, String subtitle) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Square album art container
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 130,
              height: 130,
              color: AppColors.surfaceElevated,
              child: const Icon(
                Icons.album_rounded,
                color: AppColors.textSecondary,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTile(String title, String artist, String duration) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 48,
          height: 48,
          color: AppColors.surfaceElevated,
          child: const Icon(Icons.music_note_rounded, color: AppColors.textSecondary, size: 24),
        ),
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        artist,
        style: AppTypography.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(duration, style: AppTypography.labelSmall),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
      onTap: () {},
    );
  }
}
