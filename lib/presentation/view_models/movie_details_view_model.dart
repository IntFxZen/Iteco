import 'package:flutter/foundation.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movies_repository.dart';

class MovieDetailsViewModel extends ChangeNotifier {
  final MoviesRepository repository;

  MovieDetailsViewModel(this.repository);

  MovieDetails? _movieDetails;
  bool _isLoading = false;
  String _error = '';

  MovieDetails? get movieDetails => _movieDetails;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  Future<void> loadMovieDetails(String imdbID) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _movieDetails = await repository.getMovieDetails(imdbID);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _movieDetails = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
