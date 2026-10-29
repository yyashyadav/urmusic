import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../shared/models/track.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  final service = SearchService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Search service connecting to YouTube metadata API via youtube_explode_dart.
class SearchService {
  final YoutubeExplode _yt = YoutubeExplode();

  /// Search for songs matching [query] and map them to domain [Track] models.
  Future<List<Track>> searchTracks(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final searchResults = await _yt.search.search(cleanQuery);

      final List<Track> tracks = [];
      for (final video in searchResults) {
        final duration = video.duration ?? Duration.zero;
        // Skip live streams or zero-length placeholders if necessary
        final thumbnailUrl = video.thumbnails.highResUrl.isNotEmpty
            ? video.thumbnails.highResUrl
            : video.thumbnails.mediumResUrl;

        tracks.add(
          Track(
            id: video.id.value,
            title: video.title,
            artist: video.author,
            duration: duration,
            thumbnailUrl: thumbnailUrl,
          ),
        );
      }
      return tracks;
    } catch (e) {
      // In case of network errors or parsing issues, rethrow or return empty
      return [];
    }
  }

  void dispose() {
    _yt.close();
  }
}
