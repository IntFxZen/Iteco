import '../entities/movie.dart';
import '../entities/movie_details.dart';

class SearchMoviesResult {
  final List<Movie> movies;
  final int totalResults;
  final int currentPage;

  SearchMoviesResult({
    required this.movies,
    required this.totalResults,
    required this.currentPage,
  });
}

abstract class MoviesRepository {
  Future<SearchMoviesResult> searchMovies(String query, int page);
  Future<MovieDetails> getMovieDetails(String imdbID);
}
