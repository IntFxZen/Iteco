import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.imdbID,
    required super.title,
    required super.year,
    required super.type,
    required super.poster,
    super.imdbRating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final rating = json['imdbRating'] as String?;
    return MovieModel(
      imdbID: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      type: json['Type'] as String? ?? '',
      poster: json['Poster'] as String? ?? '',
      imdbRating: (rating != null && rating != 'N/A' && rating.isNotEmpty)
          ? rating
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbID,
      'Title': title,
      'Year': year,
      'Type': type,
      'Poster': poster,
      'imdbRating': imdbRating,
    };
  }
}
