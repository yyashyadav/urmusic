import 'package:flutter_test/flutter_test.dart';
import 'package:urmusic/features/search/application/search_controller.dart';
import 'package:urmusic/features/search/data/search_service.dart';
import 'package:urmusic/shared/models/track.dart';

class FakeSearchService extends SearchService {
  List<Track> mockResults = [];
  bool shouldThrow = false;

  @override
  Future<List<Track>> searchTracks(String query) async {
    if (shouldThrow) throw Exception('Network error');
    if (query == 'empty') return [];
    return mockResults;
  }
}

void main() {
  group('SearchController tests', () {
    late FakeSearchService fakeService;
    late SearchController controller;

    setUp(() {
      fakeService = FakeSearchService();
      controller = SearchController(fakeService);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state is idle with empty query and results', () {
      expect(controller.state.status, SearchStatus.idle);
      expect(controller.state.query, '');
      expect(controller.state.results, isEmpty);
    });

    test('executeSearch with non-empty results sets status to success', () async {
      fakeService.mockResults = [
        const Track(
          id: 'test_1',
          title: 'Test Song',
          artist: 'Test Artist',
          duration: Duration(minutes: 3),
          thumbnailUrl: 'https://example.com/thumb.jpg',
        ),
      ];

      await controller.executeSearch('Test Song');

      expect(controller.state.status, SearchStatus.success);
      expect(controller.state.results.length, 1);
      expect(controller.state.results.first.title, 'Test Song');
    });

    test('executeSearch with empty results sets status to empty', () async {
      await controller.executeSearch('empty');

      expect(controller.state.status, SearchStatus.empty);
      expect(controller.state.results, isEmpty);
    });

    test('executeSearch handles error gracefully', () async {
      fakeService.shouldThrow = true;

      await controller.executeSearch('fail');

      expect(controller.state.status, SearchStatus.error);
      expect(controller.state.errorMessage, isNotNull);
    });

    test('clearSearch resets state back to idle', () async {
      fakeService.mockResults = [
        const Track(
          id: '1',
          title: 'A',
          artist: 'B',
          duration: Duration.zero,
          thumbnailUrl: '',
        ),
      ];
      await controller.executeSearch('A');
      expect(controller.state.status, SearchStatus.success);

      controller.clearSearch();
      expect(controller.state.status, SearchStatus.idle);
      expect(controller.state.query, '');
      expect(controller.state.results, isEmpty);
    });
  });
}
