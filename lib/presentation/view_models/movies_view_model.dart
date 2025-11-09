import 'package:flutter/foundation.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';

class MoviesViewModel extends ChangeNotifier {
  final MoviesRepository repository;

  MoviesViewModel(this.repository);

  List<Movie> _movies = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _error = '';
  int _currentPage = 1;
  String _searchQuery = '';
  static const String _defaultQuery = 'action';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  String get _effectiveQuery =>
      _searchQuery.trim().isEmpty ? _defaultQuery : _searchQuery.trim();

  Future<void> loadMovies({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (!_hasMore && !isRefresh) return;

    if (isRefresh) {
      _currentPage = 1;
      _movies.clear();
      _hasMore = true;
      _error = '';
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result =
          await repository.searchMovies(_effectiveQuery, _currentPage);

      if (isRefresh) {
        _movies = result.movies;
      } else {
        _movies.addAll(result.movies);
      }

      const resultsPerPage = 10;
      final totalPages = (result.totalResults / resultsPerPage).ceil();
      _hasMore = _currentPage < totalPages && result.movies.isNotEmpty;
      _currentPage++;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadMovies(isRefresh: true);
  }

  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      refresh();
    }
  }
}
