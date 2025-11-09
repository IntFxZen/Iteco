import '../../domain/entities/movie_details.dart';

class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required super.imdbID,
    required super.title,
    required super.year,
    required super.rated,
    required super.released,
    required super.runtime,
    required super.genre,
    required super.director,
    required super.writer,
    required super.actors,
    required super.plot,
    required super.language,
    required super.country,
    required super.awards,
    required super.poster,
    super.imdbRating,
    super.imdbVotes,
    super.metascore,
    required super.type,
    super.boxOffice,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      imdbID: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'N/A',
      year: json['Year'] as String? ?? 'N/A',
      rated: json['Rated'] as String? ?? 'N/A',
      released: json['Released'] as String? ?? 'N/A',
      runtime: json['Runtime'] as String? ?? 'N/A',
      genre: json['Genre'] as String? ?? 'N/A',
      director: json['Director'] as String? ?? 'N/A',
      writer: json['Writer'] as String? ?? 'N/A',
      actors: json['Actors'] as String? ?? 'N/A',
      plot: json['Plot'] as String? ?? 'N/A',
      language: json['Language'] as String? ?? 'N/A',
      country: json['Country'] as String? ?? 'N/A',
      awards: json['Awards'] as String? ?? 'N/A',
      poster: json['Poster'] as String? ?? 'N/A',
      imdbRating: _parseString(json['imdbRating']),
      imdbVotes: _parseString(json['imdbVotes']),
      metascore: _parseString(json['Metascore']),
      type: json['Type'] as String? ?? 'N/A',
      boxOffice: _parseString(json['BoxOffice']),
    );
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    if (str == 'N/A' || str.isEmpty) return null;
    return str;
  }
}


