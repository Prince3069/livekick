// ===============================
// MAIN.DART - Application Entry Point
// ===============================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:livekick/config/routes.dart';
import 'package:livekick/config/theme.dart';
import 'package:livekick/core/blocs/auth/auth_bloc.dart';
import 'package:livekick/core/blocs/matches/matches_bloc.dart';
import 'package:livekick/core/blocs/highlights/highlights_bloc.dart';
import 'package:livekick/core/blocs/stats/stats_bloc.dart';
import 'package:livekick/core/services/api_service.dart';
import 'package:livekick/core/services/firebase_service.dart';
import 'package:livekick/core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorageService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) => AuthBloc(
                  firebaseService: context.read<FirebaseService>(),
                  localStorageService: LocalStorageService(),
                )..add(AuthCheckStatusEvent()),
          ),
          BlocProvider<MatchesBloc>(
            create:
                (context) =>
                    MatchesBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<HighlightsBloc>(
            create:
                (context) =>
                    HighlightsBloc(apiService: context.read<ApiService>()),
          ),
          BlocProvider<StatsBloc>(
            create:
                (context) => StatsBloc(apiService: context.read<ApiService>()),
          ),
        ],
        child: MaterialApp(
          title: 'LiveKick',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemsseMode.system,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      ),
    );
  }
}
