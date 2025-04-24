// lib/services/rapid_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livekick/models/odds.dart';

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
}
