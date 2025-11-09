import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../view_models/movie_details_view_model.dart';
import '../../data/data_sources/movies_remote_data_source.dart';
import '../../data/repositories/movies_repository_impl.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey(movie.imdbID),
      create: (_) {
        final remoteDataSource = MoviesRemoteDataSource();
        final repository = MoviesRepositoryImpl(
          remoteDataSource: remoteDataSource,
        );
        return MovieDetailsViewModel(repository);
      },
      child: _MovieDetailsContent(movie: movie),
    );
  }
}

class _MovieDetailsContent extends StatefulWidget {
  final Movie movie;

  const _MovieDetailsContent({required this.movie});

  @override
  State<_MovieDetailsContent> createState() => _MovieDetailsContentState();
}

class _MovieDetailsContentState extends State<_MovieDetailsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MovieDetailsViewModel>()
          .loadMovieDetails(widget.movie.imdbID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 24.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.65,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.only(top: 8, left: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Consumer<MovieDetailsViewModel>(
                builder: (context, viewModel, child) {
                  final details = viewModel.movieDetails;
                  if (details == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: Row(
                      children: [
                        if (details.genre != 'N/A' && details.genre.isNotEmpty)
                          _buildGenreBadge(details.genre),
                        const SizedBox(width: 8),
                        if (details.runtime != 'N/A' &&
                            details.runtime.isNotEmpty)
                          _buildRuntimeBadge(details.runtime),
                        const SizedBox(width: 8),
                        if (details.imdbRating != null)
                          _buildSmallRatingBadge(details.imdbRating!),
                      ],
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.zero,
              background: Consumer<MovieDetailsViewModel>(
                builder: (context, viewModel, child) {
                  final details = viewModel.movieDetails;
                  if (details == null) {
                    return _buildPlaceholder(isDark);
                  }
                  return _buildHeroContent(details, isDark);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<MovieDetailsViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (viewModel.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: isDark ? Colors.white38 : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${viewModel.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final details = viewModel.movieDetails;
                if (details == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1A1A),
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildPlotSection(details, isDark),
                          const SizedBox(height: 24),
                          _buildInfoSection(details, isDark),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey[800]!, Colors.grey[900]!]
              : [Colors.grey[300]!, Colors.grey[400]!],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.movie_rounded,
          size: 80,
          color: isDark ? Colors.white24 : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildHeroContent(MovieDetails details, bool isDark) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          details.poster,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(isDark);
          },
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: details.poster.isNotEmpty && details.poster != 'N/A'
                    ? Image.network(
                        details.poster,
                        fit: BoxFit.cover,
                        height: 220,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(isDark);
                        },
                      )
                    : _buildPlaceholder(isDark),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              details.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildGenreBadge(String genre) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        genre,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRuntimeBadge(String runtime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        runtime,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSmallRatingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Colors.amber,
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            '$rating/10',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(dynamic details, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Genre', details.genre, isDark),
        if (details.director != 'N/A')
          _buildInfoRow('Director', details.director, isDark),
        if (details.actors != 'N/A')
          _buildInfoRow('Actors', details.actors, isDark),
        if (details.released != 'N/A')
          _buildInfoRow('Release Date', details.released, isDark),
        if (details.country != 'N/A')
          _buildInfoRow('Country', details.country, isDark),
        if (details.language != 'N/A')
          _buildInfoRow('Language', details.language, isDark),
        if (details.awards != 'N/A' && details.awards != '')
          _buildInfoRow('Awards', details.awards, isDark),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    if (value == 'N/A' || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlotSection(dynamic details, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plot',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
        ),
        const SizedBox(height: 12),
        Text(
          details.plot,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.grey[700],
                height: 1.6,
              ),
        ),
      ],
    );
  }
}
