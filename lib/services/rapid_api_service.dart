// // lib/services/rapid_api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:livekick/models/odds.dart';

// class RapidApiService {
//   static const String _baseUrl = 'https://api-football-v1.p.rapidapi.com/v2';
//   static const String _host = 'api-football-v1.p.rapidapi.com';
//   // Replace with your actual API key from RapidAPI
//   static const String _apiKey =
//       '7c7ac2e306mshfb32caeb7da48aap1c34ccjsna4876363090b';

//   // Singleton pattern
//   static final RapidApiService _instance = RapidApiService._internal();

//   factory RapidApiService() {
//     return _instance;
//   }

//   RapidApiService._internal();

//   // Common headers for all requests
//   Map<String, String> get _headers => {
//     'x-rapidapi-host': _host,
//     'x-rapidapi-key': _apiKey,
//   };

//   // Get odds from league filtered by bookmaker
//   Future<OddsResponse> getOddsByLeague(
//     int leagueId, {
//     String? bookmaker,
//     int page = 1,
//   }) async {
//     try {
//       String url = '$_baseUrl/odds/league/$leagueId';
//       if (bookmaker != null) {
//         url += '/bookmaker/$bookmaker';
//       }
//       if (page > 1) {
//         url += '?page=$page';
//       }

//       final response = await http.get(Uri.parse(url), headers: _headers);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return OddsResponse.fromJson(data);
//       } else {
//         throw Exception(
//           'Failed to load odds: ${response.statusCode} - ${response.body}',
//         );
//       }
//     } catch (e) {
//       throw Exception('Error getting odds data: $e');
//     }
//   }

//   // Get all available bookmakers
//   Future<List<Bookmaker>> getBookmakers() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/odds/bookmakers'),
//         headers: _headers,
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> bookmakers = data['api']['bookmakers'] ?? [];
//         return bookmakers.map((b) => Bookmaker.fromJson(b)).toList();
//       } else {
//         throw Exception('Failed to load bookmakers: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error getting bookmakers: $e');
//     }
//   }

//   // Get all available leagues
//   Future<List<LeagueInfo>> getLeagues() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/leagues'),
//         headers: _headers,
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> leagues = data['api']['leagues'] ?? [];
//         return leagues.map((l) => LeagueInfo.fromJson(l)).toList();
//       } else {
//         throw Exception('Failed to load leagues: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error getting leagues: $e');
//     }
//   }
// }

// lib/services/rapid_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livekick/models/odds.dart';
import 'package:livekick/models/match.dart';
import 'package:livekick/models/news.dart';

class RapidApiService {
  static const String _baseUrl = 'https://api-football-v1.p.rapidapi.com/v2';
  static const String _host = 'api-football-v1.p.rapidapi.com';
  // Replace with your actual API key from RapidAPI
  static const String _apiKey =
      '7c7ac2e306mshfb32caeb7da48aap1c34ccjsna4876363090b';

  // Singleton pattern
  static final RapidApiService _instance = RapidApiService._internal();

  factory RapidApiService() {
    return _instance;
  }

  RapidApiService._internal();

  // Common headers for all requests
  Map<String, String> get _headers => {
    'x-rapidapi-host': _host,
    'x-rapidapi-key': _apiKey,
  };

  // Get odds from league filtered by bookmaker
  Future<OddsResponse> getOddsByLeague(
    int leagueId, {
    String? bookmaker,
    int page = 1,
  }) async {
    try {
      String url = '$_baseUrl/odds/league/$leagueId';
      if (bookmaker != null) {
        url += '/bookmaker/$bookmaker';
      }
      if (page > 1) {
        url += '?page=$page';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return OddsResponse.fromJson(data);
      } else {
        throw Exception(
          'Failed to load odds: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting odds data: $e');
    }
  }

  // Get all available bookmakers
  Future<List<Bookmaker>> getBookmakers() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/odds/bookmakers'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> bookmakers = data['api']['bookmakers'] ?? [];
        return bookmakers.map((b) => Bookmaker.fromJson(b)).toList();
      } else {
        throw Exception('Failed to load bookmakers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting bookmakers: $e');
    }
  }

  // Get all available leagues
  Future<List<LeagueInfo>> getLeagues() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/leagues'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> leagues = data['api']['leagues'] ?? [];
        return leagues.map((l) => LeagueInfo.fromJson(l)).toList();
      } else {
        throw Exception('Failed to load leagues: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting leagues: $e');
    }
  }

  // Get fixtures (matches) by league
  Future<List<Match>> getFixturesByLeague(int leagueId) async {
    try {
      final String url = '$_baseUrl/fixtures/league/$leagueId';
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fixtures = data['api']['fixtures'] ?? [];

        return fixtures.map((fixture) {
          return Match(
            id: fixture['fixture_id'].toString(),
            homeTeam: fixture['homeTeam']['team_name'] ?? '',
            awayTeam: fixture['awayTeam']['team_name'] ?? '',
            homeScore: fixture['goalsHomeTeam'] ?? 0,
            awayScore: fixture['goalsAwayTeam'] ?? 0,
            time: _getMatchTime(fixture),
            leagueName: fixture['league']['name'] ?? '',
            isLive: fixture['status'] == 'LIVE',
            matchDate: DateTime.parse(
              fixture['event_date'] ?? DateTime.now().toIso8601String(),
            ),
          );
        }).toList();
      } else {
        throw Exception('Failed to load fixtures: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting fixtures: $e');
    }
  }

  // Get live matches
  Future<List<Match>> getLiveMatches() async {
    try {
      final String url = '$_baseUrl/fixtures/live';
      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fixtures = data['api']['fixtures'] ?? [];

        return fixtures.map((fixture) {
          return Match(
            id: fixture['fixture_id'].toString(),
            homeTeam: fixture['homeTeam']['team_name'] ?? '',
            awayTeam: fixture['awayTeam']['team_name'] ?? '',
            homeScore: fixture['goalsHomeTeam'] ?? 0,
            awayScore: fixture['goalsAwayTeam'] ?? 0,
            time: '${fixture['elapsed']}\'',
            leagueName: fixture['league']['name'] ?? '',
            isLive: true,
            matchDate: DateTime.parse(
              fixture['event_date'] ?? DateTime.now().toIso8601String(),
            ),
          );
        }).toList();
      } else {
        throw Exception('Failed to load live fixtures: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting live fixtures: $e');
    }
  }

  // Get fixtures for today
  Future<List<Match>> getFixturesByDate(DateTime date) async {
    try {
      final String formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final String url = '$_baseUrl/fixtures/date/$formattedDate';

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fixtures = data['api']['fixtures'] ?? [];

        return fixtures.map((fixture) {
          return Match(
            id: fixture['fixture_id'].toString(),
            homeTeam: fixture['homeTeam']['team_name'] ?? '',
            awayTeam: fixture['awayTeam']['team_name'] ?? '',
            homeScore: fixture['goalsHomeTeam'] ?? 0,
            awayScore: fixture['goalsAwayTeam'] ?? 0,
            time: _getMatchTime(fixture),
            leagueName: fixture['league']['name'] ?? '',
            isLive: fixture['status'] == 'LIVE',
            matchDate: DateTime.parse(
              fixture['event_date'] ?? DateTime.now().toIso8601String(),
            ),
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load fixtures by date: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting fixtures by date: $e');
    }
  }

  // Get football news (simulated as API might not provide this)
  Future<List<News>> getFootballNews() async {
    // In a real app, you would connect to a news API
    // This is a mock implementation
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay

    return [
      News(
        id: '1',
        title: 'Messi scores hat-trick in Champions League thriller',
        imageUrl: 'https://via.placeholder.com/300',
        publishedAt: DateTime.now().subtract(Duration(hours: 3)),
        content:
            'Lionel Messi delivered yet another masterclass performance in the Champions League, scoring three goals...',
      ),
      News(
        id: '2',
        title:
            'Premier League announces new broadcasting deal worth £5 billion',
        imageUrl: 'https://via.placeholder.com/300',
        publishedAt: DateTime.now().subtract(Duration(hours: 6)),
        content:
            'The Premier League has signed a record-breaking new broadcasting deal that will run for the next four seasons...',
      ),
      News(
        id: '3',
        title: 'Liverpool signs promising young defender from Ajax',
        imageUrl: 'https://via.placeholder.com/300',
        publishedAt: DateTime.now().subtract(Duration(hours: 12)),
        content:
            'Liverpool FC has completed the signing of a highly-rated young defender from Ajax Amsterdam...',
      ),
      News(
        id: '4',
        title: 'World Cup 2026: FIFA unveils new stadium requirements',
        imageUrl: 'https://via.placeholder.com/300',
        publishedAt: DateTime.now().subtract(Duration(hours: 24)),
        content:
            'FIFA has announced updated stadium requirements for the upcoming 2026 World Cup...',
      ),
    ];
  }

  // Helper method to format match time
  String _getMatchTime(dynamic fixture) {
    if (fixture['status'] == 'LIVE') {
      return '${fixture['elapsed']}\'';
    } else if (fixture['status'] == 'FT') {
      return 'FT';
    } else if (fixture['status'] == 'HT') {
      return 'HT';
    } else {
      // Parse the event_date to get the time
      final dateTime = DateTime.parse(fixture['event_date']);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
