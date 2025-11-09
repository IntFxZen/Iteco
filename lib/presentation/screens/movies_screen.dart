import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/movies_view_model.dart';
import '../view_models/theme_view_model.dart';
import '../widgets/movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoviesViewModel>().loadMovies();
    });
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    _searchFocusNode.unfocus();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<MoviesViewModel>().loadMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final padding = screenWidth > 600 ? 24.0 : 16.0;

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
          elevation: 0,
          actions: [
            Consumer<ThemeViewModel>(
              builder: (context, themeViewModel, child) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  ),
                  tooltip: isDark ? 'Light Theme' : 'Dark Theme',
                  onPressed: () {
                    themeViewModel.toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white38
                        : Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.grey[600],
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white54
                                    : Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                            context
                                .read<MoviesViewModel>()
                                .updateSearchQuery('');
                            _searchFocusNode.unfocus();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1A1A1A)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  context
                      .read<MoviesViewModel>()
                      .updateSearchQuery(value.trim());
                  _searchFocusNode.unfocus();
                },
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    context.read<MoviesViewModel>().updateSearchQuery('');
                  }
                },
              ),
            ),
            Expanded(
              child: Consumer<MoviesViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.hasError && viewModel.movies.isEmpty) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => viewModel.refresh(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (viewModel.movies.isEmpty && viewModel.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }

                  if (viewModel.movies.isEmpty && !viewModel.isLoading) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 80,
                            color: isDark ? Colors.white24 : Colors.grey[300],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Start searching for movies',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[700],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter a movie title in the search bar',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => viewModel.refresh(),
                    color: Theme.of(context).colorScheme.primary,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(padding),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return MovieCard(
                                    movie: viewModel.movies[index]);
                              },
                              childCount: viewModel.movies.length,
                            ),
                          ),
                        ),
                        if (viewModel.hasMore)
                          const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
