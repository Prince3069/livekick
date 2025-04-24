// lib/repositories/odds_repository.dart
import 'package:livekick/models/odds.dart';
import 'package:livekick/services/rapid_api_service.dart';

class OddsRepository {
  final RapidApiService _apiService = RapidApiService();

  // Singleton pattern
  static final OddsRepository _instance = OddsRepository._internal();

  factory OddsRepository() {
    return _instance;
  }

  OddsRepository._internal();

  // Get odds for a specific league
  Future<OddsResponse> getOddsForLeague(
    int leagueId, {
    String? bookmaker,
    int page = 1,
  }) async {
    return await _apiService.getOddsByLeague(
      leagueId,
      bookmaker: bookmaker,
      page: page,
    );
  }

  // Get available bookmakers
  Future<List<Bookmaker>> getBookmakers() async {
    return await _apiService.getBookmakers();
  }

  // Get available leagues
  Future<List<LeagueInfo>> getLeagues() async {
    return await _apiService.getLeagues();
  }
}
