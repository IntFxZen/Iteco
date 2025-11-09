class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String type;
  final String poster;
  final String? imdbRating;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
    this.imdbRating,
  });
}
