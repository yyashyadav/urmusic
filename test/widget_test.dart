import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urmusic/app/app.dart';

void main() {
  testWidgets('UrMusicApp smoke test and navigation verification', (WidgetTester tester) async {
    // Build app wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: UrMusicApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Home tab is selected and MiniPlayer is present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('No song playing'), findsOneWidget);

    // Tap Search tab
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Verify Search tab is selected and displays search header
    expect(find.text('Top Genres & Moods'), findsOneWidget);

    // Tap Library tab
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    // Verify Library tab is selected
    expect(find.text('Favorites'), findsOneWidget);
  });
}
