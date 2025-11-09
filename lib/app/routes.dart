import 'package:flutter/material.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/movies_screen.dart';
import '../presentation/screens/movie_details_screen.dart';
import '../domain/entities/movie.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String movies = '/movies';
  static const String movieDetails = '/movie-details';

  static final routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    movies: (context) => const MoviesScreen(),
    movieDetails: (context) {
      final movie = ModalRoute.of(context)!.settings.arguments as Movie;
      return MovieDetailsScreen(movie: movie);
    },
  };
}
