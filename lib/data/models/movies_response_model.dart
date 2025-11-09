import 'movie_model.dart';

class MoviesResponseModel {
  final List<MovieModel> movies;
  final int totalResults;
  final bool response;
  final String? error;

  MoviesResponseModel({
    required this.movies,
    required this.totalResults,
    required this.response,
    this.error,
  });

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> searchResults = json['Search'] as List<dynamic>? ?? [];
    final responseString = json['Response'] as String? ?? 'False';

    return MoviesResponseModel(
      movies: searchResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalResults: int.tryParse(json['totalResults'] as String? ?? '0') ?? 0,
      response: responseString == 'True',
      error: json['Error'] as String?,
    );
  }
}
