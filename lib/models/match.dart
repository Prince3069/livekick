// lib/models/match.dart
class Match {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String time;
  final String leagueName;
  final bool isLive;
  final DateTime matchDate;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.time,
    required this.leagueName,
    required this.isLive,
    required this.matchDate,
  });

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      homeTeam: map['homeTeam'],
      awayTeam: map['awayTeam'],
      homeScore: map['homeScore'],
      awayScore: map['awayScore'],
      time: map['time'],
      leagueName: map['leagueName'],
      isLive: map['isLive'],
      matchDate: DateTime.parse(map['matchDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'time': time,
      'leagueName': leagueName,
      'isLive': isLive,
      'matchDate': matchDate.toIso8601String(),
    };
  }
}
