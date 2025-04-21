
// ===============================
// CORE/MODELS/MATCH_MODEL.DART
// ===============================

import 'package:equatable/equatable.dart';

enum MatchStatus {
  scheduled,
  live,
  finished,
  postponed,
  cancelled,
}

class Match extends Equatable {
  final String id;
  final String leagueId;
  final String leagueName;
  final String homeTeamId;
  final String homeTeamName;
  final String homeTeamLogo;
  final String awayTeamId;
  final String awayTeamName;
  final String awayTeamLogo;
  final DateTime dateTime;
  final MatchStatus status;
  final int? homeScore;
  final int? awayScore;
  final String? stadium;
  final String? referee;
  final int? minute;
  final bool isHighlighted;
  final String? streamUrl;

  const Match({
    required this.id,
    required this.leagueId,
    required this.leagueName,
    required this.homeTeamId,
    required this.homeTeamName,
    required this.homeTeamLogo,
    required this.awayTeamId,
    required this.awayTeamName,
    required this.awayTeamLogo,
    required this.dateTime,
    required this.status,
    this.homeScore,
    this.awayScore,
    this.stadium,
    this.referee,
    this.minute,
    this.isHighlighted = false,
    this.streamUrl,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      leagueId: json['leagueId'] as String,
      leagueName: json['leagueName'] as String,
      homeTeamId: json['homeTeamId'] as String,
      homeTeamName: json['homeTeamName'] as String,
      homeTeamLogo: json['homeTeamLogo'] as String,
      awayTeamId: json['awayTeamId'] as String,
      awayTeamName: json['awayTeamName'] as String,
      awayTeamLogo: json['awayTeamLogo'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: MatchStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MatchStatus.scheduled,
      ),
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      stadium: json['stadium'] as String?,
      referee: json['referee'] as String?,
      minute: json['minute'] as int?,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      streamUrl: json['streamUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leagueId': leagueId,
      'leagueName': leagueName,
      'homeTeamId': homeTeamId,
      'homeTeamName': homeTeamName,
      'homeTeamLogo': homeTeamLogo,
      'awayTeamId': awayTeamId,
      'awayTeamName': awayTeamName,
      'awayTeamLogo': awayTeamLogo,
      'dateTime': dateTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'stadium': stadium,
      'referee': referee,
      'minute': minute,
      'isHighlighted': isHighlighted,
      'streamUrl': streamUrl,
    };
  }

  bool get isLive => status == MatchStatus.live;
  bool get isFinished => status == MatchStatus.finished;
  bool get isScheduled => status == MatchStatus.scheduled;
  bool get hasScore => homeScore != null && awayScore != null;

  @override
  List<Object?> get props => [
        id,
        leagueId,
        leagueName,
        homeTeamId,
        homeTeamName,
        homeTeamLogo,
        awayTeamId,
        awayTeamName,
        awayTeamLogo,
        dateTime,
        status,
        homeScore,
        awayScore,
        stadium,
        referee,
        minute,
        isHighlighted,
        streamUrl,
      ];
}