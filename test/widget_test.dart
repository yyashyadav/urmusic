import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urmusic/app/app.dart';

void main() {
  testWidgets('UrMusicApp smoke test and navigation verification', (
    WidgetTester tester,
  ) async {
    // Set a realistic phone size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build app wrapped in ProviderScope
    await tester.pumpWidget(const ProviderScope(child: UrMusicApp()));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Home tab is selected, Yash greeting is displayed, and sections exist
    expect(find.text('Yash 👋'), findsOneWidget);
    expect(find.text('Recently Played'), findsOneWidget);
    expect(find.text('Made for You'), findsOneWidget);
    expect(find.text('Trending Now', skipOffstage: false), findsOneWidget);

    // Verify MiniPlayer displays the initial track
    expect(find.text('Golden Hour', skipOffstage: false), findsWidgets);

    // Tap MiniPlayer to open NowPlayingScreen
    await tester.tap(find.text('Golden Hour').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Now Playing screen elements
    expect(find.text('NOW PLAYING'), findsOneWidget);
    expect(find.text('JVKE'), findsWidgets);
    expect(find.text('Up Next'), findsOneWidget);

    // Tap back button on Now Playing screen
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tap Search tab icon
    await tester.tap(find.byIcon(Icons.search_rounded).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Your Library tab icon
    await tester.tap(find.byIcon(Icons.play_circle_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Playlists tab icon
    await tester.tap(find.byIcon(Icons.queue_music_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Profile tab icon
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  });
}
