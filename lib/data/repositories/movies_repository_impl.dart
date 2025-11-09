import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movies_repository.dart';
import '../data_sources/movies_remote_data_source.dart';
import '../models/movie_details_model.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;

  MoviesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SearchMoviesResult> searchMovies(String query, int page) async {
    final response = await remoteDataSource.searchMovies(query, page);

    if (!response.response) {
      throw Exception(response.error ?? 'Unknown error');
    }

    return SearchMoviesResult(
      movies: response.movies,
      totalResults: response.totalResults,
      currentPage: page,
    );
  }

  @override
  Future<MovieDetails> getMovieDetails(String imdbID) async {
    final jsonData = await remoteDataSource.getMovieDetails(imdbID);
    return MovieDetailsModel.fromJson(jsonData);
  }
}
