// ===============================
// CONFIG/ROUTES.DART - App Navigation
// ===============================

import 'package:flutter/material.dart';
import 'package:livekick/ui/screens/splash_screen.dart';
import 'package:livekick/ui/screens/auth/login_screen.dart';
import 'package:livekick/ui/screens/auth/register_screen.dart';
import 'package:livekick/ui/screens/home_screen.dart';
import 'package:livekick/ui/screens/match_detail_screen.dart';
import 'package:livekick/ui/screens/highlights_screen.dart';
import 'package:livekick/ui/screens/stats_screen.dart';
import 'package:livekick/ui/screens/profile_screen.dart';
import 'package:livekick/ui/screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String matchDetail = '/match-detail';
  static const String highlights = '/highlights';
  static const String stats = '/stats';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case matchDetail:
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MatchDetailScreen(matchId: args['matchId']),
        );
      case highlights:
        return MaterialPageRoute(builder: (_) => HighlightsScreen());
      case stats:
        return MaterialPageRoute(builder: (_) => StatsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
