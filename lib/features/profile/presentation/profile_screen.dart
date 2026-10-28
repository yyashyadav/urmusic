import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../shared/data/mock_music_data.dart';
import 'widgets/profile_settings_tile.dart';
import 'widgets/profile_stat_card.dart';

/// Profile screen matching UIDesign/Profile.png:
/// - Circular avatar with subtle glow
/// - Name & subtitle
/// - "Edit profile" pill button
/// - Stats row (324 Liked songs, 4 Playlists, 3 Daily mixes)
/// - Settings list (Account, Notifications, Playback, Audio quality, Privacy, Help & support)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Circular Avatar
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: AppNetworkImage(
                      url: MockMusicData.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                'Yash',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                'Music lover',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              // Edit Profile Button
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile coming soon'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.glassBorder, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                ),
                child: Text(
                  'Edit profile',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Stats Row (324 Liked songs, 4 Playlists, 3 Daily mixes)
              const Row(
                children: [
                  ProfileStatCard(count: '324', label: 'Liked songs'),
                  SizedBox(width: 12),
                  ProfileStatCard(count: '4', label: 'Playlists'),
                  SizedBox(width: 12),
                  ProfileStatCard(count: '3', label: 'Daily mixes'),
                ],
              ),
              const SizedBox(height: 28),
              // Settings List
              ProfileSettingsTile(
                icon: Icons.person_outline_rounded,
                label: 'Account',
                onTap: () {},
              ),
              ProfileSettingsTile(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
                onTap: () {},
              ),
              ProfileSettingsTile(
                icon: Icons.play_circle_outline_rounded,
                label: 'Playback',
                onTap: () {},
              ),
              ProfileSettingsTile(
                icon: Icons.graphic_eq_rounded,
                label: 'Audio quality',
                onTap: () {},
              ),
              ProfileSettingsTile(
                icon: Icons.lock_outline_rounded,
                label: 'Privacy',
                onTap: () {},
              ),
              ProfileSettingsTile(
                icon: Icons.help_outline_rounded,
                label: 'Help & support',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
