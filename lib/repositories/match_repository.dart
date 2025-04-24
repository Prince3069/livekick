// lib/repositories/match_repository.dart
import 'package:livekick/models/match.dart';
import 'package:livekick/services/rapid_api_service.dart';

class MatchRepository {
  final RapidApiService _apiService = RapidApiService();

  Future<List<Match>> getLiveMatches() async {
    try {
      return await _apiService.getLiveMatches();
    } catch (e) {
      throw Exception('Failed to load live matches: $e');
    }
  }

  Future<List<Match>> getMatchesByDate(DateTime date) async {
    try {
      return await _apiService.getFixturesByDate(date);
    } catch (e) {
      throw Exception('Failed to load matches by date: $e');
    }
  }

  Future<List<Match>> getUpcomingMatches() async {
    try {
      final today = DateTime.now();
      final matches = await _apiService.getFixturesByDate(today);

      // Filter to get only upcoming matches (not started yet)
      return matches
          .where(
            (match) => !match.isLive && match.matchDate.isAfter(DateTime.now()),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load upcoming matches: $e');
    }
  }

  Future<List<Match>> getFeaturedMatches() async {
    try {
      // Get both live matches and upcoming high-profile matches
      final liveMatches = await getLiveMatches();
      final upcomingMatches = await getUpcomingMatches();

      // Combine and limit to a reasonable number
      final allMatches = [...liveMatches, ...upcomingMatches];
      return allMatches.take(5).toList();
    } catch (e) {
      throw Exception('Failed to load featured matches: $e');
    }
  }
}
