
// ===============================
// CORE/BLOCS/STATS/STATS_BLOC.DART
// ===============================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekick/core/models/stats_model.dart';
import 'package:livekick/core/services/api_service.dart';

// Events
abstract class StatsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMatchStatsEvent extends StatsEvent {
  final String matchId;

  LoadMatchStatsEvent({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}

class LoadTeamStatsEvent extends StatsEvent {
  final String teamId;
  final String? competitionId;
  final int? seasonYear;

  LoadTeamStatsEvent({
    required this.teamId,
    this.competitionId,
    this.seasonYear,
  });

  @override
  List<Object?> get props => [teamId, competitionId, seasonYear];
}

// States
abstract class StatsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class MatchStatsLoaded extends StatsState {
  final MatchStats stats;

  MatchStatsLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class TeamStatsLoaded extends StatsState {
  final Map<String, dynamic> teamStats;
  final String teamId;
  final String? competitionId;
  final int? seasonYear;

  TeamStatsLoaded({
    required this.teamStats,
    required this.teamId,
    this.competitionId,
    this.seasonYear,
  });

  @override
  List<Object?> get props => [teamStats, teamId, competitionId, seasonYear];
}

class StatsFailure extends StatsState {
  final String message;

  StatsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final ApiService apiService;

  StatsBloc({required this.apiService}) : super(StatsInitial()) {
    on<LoadMatchStatsEvent>(_onLoadMatchStats);
    on<LoadTeamStatsEvent>(_onLoadTeamStats);
  }

  void _onLoadMatchStats(LoadMatchStatsEvent event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      final stats = await apiService.getMatchStats(event.matchId);
      emit(MatchStatsLoaded(stats: stats));
    } catch (e) {
      emit(StatsFailure(message: 'Failed to load match stats: ${e.toString()}'));
    }
  }

  void _onLoadTeamStats(LoadTeamStatsEvent event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      final teamStats = await apiService.getTeamStats(
        event.teamId,
        competitionId: event.competitionId,
        seasonYear: event.seasonYear,
      );
      emit(TeamStatsLoaded(
        teamStats: teamStats,
        teamId: event.teamId,
        competitionId: event.competitionId,
        seasonYear: event.seasonYear,
      ));
    } catch (e) {
      emit(StatsFailure(message: 'Failed to load team stats: ${e.toString()}'));
    }
  }
}