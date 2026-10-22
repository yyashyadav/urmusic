import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/player/presentation/mini_player.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows scrolling content to blur beneath the bottom bar
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
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
                  // Docked MiniPlayer directly above the bottom nav bar
                  const MiniPlayer(),

                  // Hairline divider between MiniPlayer and NavigationBar
                  const Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: AppColors.glassBorder,
                  ),

                  // Clean, professional NavigationBar (BlackHole + iOS blur)
                  NavigationBar(
                    selectedIndex: _currentIndex,
                    backgroundColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    elevation: 0,
                    height: 58,
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                    onDestinationSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
                        selectedIcon: Icon(Icons.home_rounded, color: AppColors.accent),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.search_rounded, color: AppColors.textSecondary),
                        selectedIcon: Icon(Icons.search_rounded, color: AppColors.accent),
                        label: 'Search',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.library_music_outlined, color: AppColors.textSecondary),
                        selectedIcon: Icon(Icons.library_music_rounded, color: AppColors.accent),
                        label: 'Library',
                      ),
                    ],
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
