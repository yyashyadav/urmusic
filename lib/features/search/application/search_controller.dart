import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/track.dart';
import '../data/search_service.dart';

enum SearchStatus { idle, loading, success, empty, error }

class SearchState {
  final String query;
  final SearchStatus status;
  final List<Track> results;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    List<Track>? results,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }
}

class SearchController extends StateNotifier<SearchState> {
  final SearchService _searchService;
  Timer? _debounceTimer;

  SearchController(this._searchService) : super(const SearchState());

  /// Debounces query keystrokes (450ms) before executing live search.
  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      state = const SearchState(query: '', status: SearchStatus.idle);
      return;
    }

    state = state.copyWith(query: query, status: SearchStatus.loading);
    _debounceTimer = Timer(const Duration(milliseconds: 450), () {
      executeSearch(query);
    });
  }

  /// Immediately runs search for [query].
  Future<void> executeSearch(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      state = const SearchState(query: '', status: SearchStatus.idle);
      return;
    }

    state = state.copyWith(query: cleanQuery, status: SearchStatus.loading);
    try {
      final results = await _searchService.searchTracks(cleanQuery);
      if (results.isEmpty) {
        state = state.copyWith(status: SearchStatus.empty, results: []);
      } else {
        state = state.copyWith(status: SearchStatus.success, results: results);
      }
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Unable to search right now. Check connection.',
      );
    }
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    state = const SearchState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
  final searchService = ref.watch(searchServiceProvider);
  return SearchController(searchService);
});
