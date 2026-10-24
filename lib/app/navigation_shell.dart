import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/playlists/presentation/playlists_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/player/presentation/mini_player.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  void _onSelectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onSearchTap: () => _onSelectTab(1),
        onProfileTap: () => _onSelectTab(4),
      ),
      const SearchScreen(),
      const LibraryScreen(),
      const PlaylistsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.glassSurface,
              border: Border(
                top: BorderSide(color: AppColors.glassBorder, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // MiniPlayer card docked above navigation bar
                  const MiniPlayer(),

                  const Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: AppColors.glassBorder,
                  ),

                  // 5-Tab Navigation Bar matching UIDesign
                  NavigationBarTheme(
                    data: NavigationBarThemeData(
                      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentLight,
                            );
                          }
                          return const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          );
                        },
                      ),
                      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return const IconThemeData(
                              color: AppColors.accentLight,
                              size: 24,
                            );
                          }
                          return const IconThemeData(
                            color: AppColors.textMuted,
                            size: 24,
                          );
                        },
                      ),
                    ),
                    child: NavigationBar(
                      selectedIndex: _currentIndex,
                      backgroundColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      elevation: 0,
                      height: 58,
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      onDestinationSelected: _onSelectTab,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_rounded),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.search_rounded),
                          selectedIcon: Icon(Icons.search_rounded),
                          label: 'Search',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.play_circle_outline_rounded),
                          selectedIcon: Icon(Icons.play_circle_filled_rounded),
                          label: 'Your Library',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.queue_music_rounded),
                          selectedIcon: Icon(Icons.queue_music_rounded),
                          label: 'Playlists',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outline_rounded),
                          selectedIcon: Icon(Icons.person_rounded),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
