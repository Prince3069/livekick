// ===============================
// CORE/SERVICES/API_SERVICE.DART
// ===============================

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livekick/core/models/match_model.dart';
import 'package:livekick/core/models/highlight_model.dart';
import 'package:livekick/core/models/stats_model.dart';
import 'package:livekick/core/services/local_storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  final String baseUrl = 'https://api.livekick.app/v1';
  final LocalStorageService _localStorageService = LocalStorageService();
  
  Future<Map<String, String>> _getHeaders() async {
    final token = await _localStorageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Matches API
  Future<List<Match>> getMatches({
    DateTime? date,
    String? leagueId,
    String? teamId,
  }) async {
    final Map<String, String> queryParams = {};
    
    if (date != null) {
      queryParams['date'] = date.toIso8601String().split('T')[0];
    }
    
    if (leagueId != null) {
      queryParams['leagueId'] = leagueId;
    }
    
    if (teamId != null) {
      queryParams['teamId'] = teamId;
    }
    
    final Uri uri = Uri.parse('$baseUrl/matches').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    
    final response = await http.get(uri, headers: await _getHeaders());
    
    if (response.statusCode == 200) {
      final List<dynamic> matchesJson = jsonDecode(response.body)['data'];
      return matchesJson.map((json) => Match.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load matches: ${response.statusCode}');
    }
  }

  Future<List<Match>> getLiveMatches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/matches/live'),
      headers: await _getHeaders(),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> matchesJson = jsonDecode(response.body)['data'];
      return matchesJson.map((json) => Match.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load live matches: ${response.statusCode}');
    }
  }

  Future<Match> getMatchDetails(String matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/matches/$matchId'),
      headers: await _getHeaders(),
    );
    
    if (response.statusCode == 200) {
      return Match.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load match details: ${response.statusCode}');
    }
  }

  Stream<Match> getMatchUpdatesStream(String matchId) {
    final token = _localStorageService.getAuthToken();
    final wsUri = Uri.parse('wss://ws.livekick.app/matches/$matchId/live');
    
    final channel = WebSocketChannel.connect(wsUri);
    
    if (token != null) {
      channel.sink.add(jsonEncode({'type': 'auth', 'token': token}));
    }
    
    return channel.stream.map((event) {
      final data = jsonDecode(event);
      if (data['type'] == 'match_update') {
        return Match.fromJson(data['data']);
      } else {
        throw Exception('Unknown event type: ${data['type']}');
      }
    });
  }

  // Highlights API
  Future<HighlightsResult> getHighlights({
    String? matchId,
    String? teamId,
    int page = 1,
    int limit = 10,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (matchId != null) {
      queryParams['matchId'] = matchId;
    }
    
    if (teamId != null) {
      queryParams['teamId'] = teamId;
    }
    
    final Uri uri = Uri.parse('$baseUrl/highlights').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(uri, headers: await _getHeaders());
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> highlightsJson = data['data'];
      final int total = data['meta']['total'];
      final int pages = (total / limit).ceil();
      
      return HighlightsResult(
        highlights: highlightsJson.map((json) => Highlight.fromJson(json)).toList(),
        hasMorePages: page < pages,
      );
    } else {
      throw Exception('Failed to load highlights: ${response.statusCode}');
    }
  }

  Future<Highlight> getHighlightDetails(String highlightId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/highlights/$highlightId'),
      headers: await _getHeaders(),
    );
    
    if (response.statusCode == 200) {
      return Highlight.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load highlight details: ${response.statusCode}');
    }
  }

  Future<void> increaseHighlightViews(String highlightId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/highlights/$highlightId/views'),
      headers: await _getHeaders(),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update highlight views: ${response.statusCode}');
    }
  }

  // Stats API
  Future<MatchStats> getMatchStats(String matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats/matches/$matchId'),
      headers: await _getHeaders(),
    );
    
    if (response.statusCode == 200) {
      return MatchStats.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load match stats: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getTeamStats(
    String teamId, {
    String? competitionId,
    int? seasonYear,
  }) async {
    final Map<String, String> queryParams = {};
    
    if (competitionId != null) {
      queryParams['competitionId'] = competitionId;
    }
    
    if (seasonYear != null) {
      queryParams['seasonYear'] = seasonYear.toString();
    }
    
    final Uri uri = Uri.parse('$baseUrl/stats/teams/$teamId').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    
    final response = await http.get(uri, headers: await _getHeaders());
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load team stats: ${response.statusCode}');
    }
  }
}

class HighlightsResult {
  final List<Highlight> highlights;
  final bool hasMorePages;

  HighlightsResult({
    required this.highlights,
    required this.hasMorePages,
  });
}
