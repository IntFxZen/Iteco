import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'theme.dart';
import '../presentation/view_models/movies_view_model.dart';
import '../presentation/view_models/theme_view_model.dart';
import '../data/data_sources/movies_remote_data_source.dart';
import '../data/repositories/movies_repository_impl.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final remoteDataSource = MoviesRemoteDataSource();
            final repository = MoviesRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return MoviesViewModel(repository);
          },
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'Movie App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
