import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movies_response_model.dart';

class MoviesRemoteDataSource {
  static const String _baseUrl = 'https://www.omdbapi.com/';
  static const String _apiKey = '7d907061';

  Future<MoviesResponseModel> searchMovies(String query, int page) async {
    final uri =
        Uri.parse('$_baseUrl?apikey=$_apiKey&s=$query&page=$page&type=movie');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }

    final jsonData = json.decode(response.body) as Map<String, dynamic>;

    if (jsonData['Response'] == 'False') {
      throw Exception(jsonData['Error'] as String? ?? 'Unknown error');
    }

    return MoviesResponseModel.fromJson(jsonData);
  }

  Future<Map<String, dynamic>> getMovieDetails(String imdbID) async {
    final uri = Uri.parse('$_baseUrl?apikey=$_apiKey&i=$imdbID');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details: ${response.statusCode}');
    }

    final jsonData = json.decode(response.body) as Map<String, dynamic>;

    if (jsonData['Response'] == 'False') {
      throw Exception(jsonData['Error'] as String? ?? 'Unknown error');
    }

    return jsonData;
  }
}
