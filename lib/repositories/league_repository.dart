// lib/repositories/league_repository.dart
import 'package:livekick/models/league.dart';
import 'package:livekick/services/rapid_api_service.dart';

class LeagueRepository {
  final RapidApiService _apiService = RapidApiService();

  Future<List<LeagueInfo>> getLeagues() async {
    try {
      return await _apiService.getLeagues();
    } catch (e) {
      throw Exception('Failed to load leagues: $e');
    }
  }

  // Get matches for a specific league
  Future<List<Match>> getMatchesByLeague(int leagueId) async {
    try {
      final fixtures = await _apiService.getFixturesByLeague(leagueId);
      return fixtures;
    } catch (e) {
      throw Exception('Failed to load matches: $e');
    }
  }
}
