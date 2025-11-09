class MovieDetails {
  final String imdbID;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final String? imdbRating;
  final String? imdbVotes;
  final String? metascore;
  final String type;
  final String? boxOffice;

  MovieDetails({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    this.imdbRating,
    this.imdbVotes,
    this.metascore,
    required this.type,
    this.boxOffice,
  });
}


