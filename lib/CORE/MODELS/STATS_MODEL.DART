
// ===============================
// CORE/MODELS/STATS_MODEL.DART
// ===============================

import 'package:equatable/equatable.dart';

class MatchStats extends Equatable {
  final String matchId;
  final int possession; // Home team possession percentage (away is 100 - possession)
  final int shotsHome;
  final int shotsAway;
  final int shotsOnTargetHome;
  final int shotsOnTargetAway;
  final int cornersHome;
  final int cornersAway;
  final int foulsHome;
  final int foulsAway;
  final int yellowCardsHome;
  final int yellowCardsAway;
  final int redCardsHome;
  final int redCardsAway;
  final int offsideHome;
  final int offsideAway;
  final List<MatchEvent> events;

  const MatchStats({
    required this.matchId,
    required this.possession,
    required this.shotsHome,
    required this.shotsAway,
    required this.shotsOnTargetHome,
    required this.shotsOnTargetAway,
    required this.cornersHome,
    required this.cornersAway,
    required this.foulsHome,
    required this.foulsAway,
    required this.yellowCardsHome,
    required this.yellowCardsAway,
    required this.redCardsHome,
    required this.redCardsAway,
    required this.offsideHome,
    required this.offsideAway,
    required this.events,
  });

  factory MatchStats.fromJson(Map<String, dynamic> json) {
    return MatchStats(
      matchId: json['matchId'] as String,
      possession: json['possession'] as int,
      shotsHome: json['shotsHome'] as int,
      shotsAway: json['shotsAway'] as int,
      shotsOnTargetHome: json['shotsOnTargetHome'] as int,
      shotsOnTargetAway: json['shotsOnTargetAway'] as int,
      cornersHome: json['cornersHome'] as int,
      cornersAway: json['cornersAway'] as int,
      foulsHome: json['foulsHome'] as int,
      foulsAway: json['foulsAway'] as int,
      yellowCardsHome: json['yellowCardsHome'] as int,
      yellowCardsAway: json['yellowCardsAway'] as int,
      redCardsHome: json['redCardsHome'] as int,
      redCardsAway: json['redCardsAway'] as int,
      offsideHome: json['offsideHome'] as int,
      offsideAway: json['offsideAway'] as int,
      events: (json['events'] as List)
          .map((e) => MatchEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'possession': possession,
      'shotsHome': shotsHome,
      'shotsAway': shotsAway,
      'shotsOnTargetHome': shotsOnTargetHome,
      'shotsOnTargetAway': shotsOnTargetAway,
      'cornersHome': cornersHome,
      'cornersAway': cornersAway,
      'foulsHome': foulsHome,
      'foulsAway': foulsAway,
      'yellowCardsHome': yellowCardsHome,
      'yellowCardsAway': yellowCardsAway,
      'redCardsHome': redCardsHome,
      'redCardsAway': redCardsAway,
      'offsideHome': offsideHome,
      'offsideAway': offsideAway,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        matchId,
        possession,
        shotsHome,
        shotsAway,
        shotsOnTargetHome,
        shotsOnTargetAway,
        cornersHome,
        cornersAway,
        foulsHome,
        foulsAway,
        yellowCardsHome,
        yellowCardsAway,
        redCardsHome,
        redCardsAway,
        offsideHome,
        offsideAway,
        events,
      ];
}

enum EventType {
  goal,
  ownGoal,
  penalty,
  missedPenalty,
  yellowCard,
  redCard,
  substitution,
}

class MatchEvent extends Equatable {
  final String id;
  final EventType type;
  final int minute;
  final String playerId;
  final String playerName;
  final String teamId;
  final bool isHomeTeam;
  final String? assistPlayerId;
  final String? assistPlayerName;
  final String? substitutedPlayerId;
  final String? substitutedPlayerName;

  const MatchEvent({
    required this.id,
    required this.type,
    required this.minute,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.isHomeTeam,
    this.assistPlayerId,
    this.assistPlayerName,
    this.substitutedPlayerId,
    this.substitutedPlayerName,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      id: json['id'] as String,
      type: EventType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => EventType.goal,
      ),
      minute: json['minute'] as int,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      teamId: json['teamId'] as String,
      isHomeTeam: json['isHomeTeam'] as bool,
      assistPlayerId: json['assistPlayerId'] as String?,
      assistPlayerName: json['assistPlayerName'] as String?,
      substitutedPlayerId: json['substitutedPlayerId'] as String?,
      substitutedPlayerName: json['substitutedPlayerName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'minute': minute,
      'playerId': playerId,
      'playerName': playerName,
      'teamId': teamId,
      'isHomeTeam': isHomeTeam,
      'assistPlayerId': assistPlayerId,
      'assistPlayerName': assistPlayerName,
      'substitutedPlayerId': substitutedPlayerId,
      'substitutedPlayerName': substitutedPlayerName,
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        minute,
        playerId,
        playerName,
        teamId,
        isHomeTeam,
        assistPlayerId,
        assistPlayerName,
        substitutedPlayerId,
        substitutedPlayerName,
      ];
}
