
// ===============================
// CORE/BLOCS/MATCHES/MATCHES_BLOC.DART
// ===============================

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekick/core/models/match_model.dart';
import 'package:livekick/core/services/api_service.dart';

// Events
abstract class MatchesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMatchesEvent extends MatchesEvent {
  final DateTime? date;
  final String? leagueId;
  final String? teamId;

  LoadMatchesEvent({this.date, this.leagueId, this.teamId});

  @override
  List<Object?> get props => [date, leagueId, teamId];
}

class LoadLiveMatchesEvent extends MatchesEvent {}

class LoadMatchDetailsEvent extends MatchesEvent {
  final String matchId;

  LoadMatchDetailsEvent({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}

class StartMatchUpdatesEvent extends MatchesEvent {
  final String matchId;

  StartMatchUpdatesEvent({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}

class StopMatchUpdatesEvent extends MatchesEvent {}

// States
abstract class MatchesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MatchesInitial extends MatchesState {}

class MatchesLoading extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<Match> matches;
  final DateTime? date;
  final String? leagueId;
  final String? teamId;

  MatchesLoaded({
    required this.matches,
    this.date,
    this.leagueId,
    this.teamId,
  });

  @override
  List<Object?> get props => [matches, date, leagueId, teamId];
}

class LiveMatchesLoaded extends MatchesState {
  final List<Match> liveMatches;

  LiveMatchesLoaded({required this.liveMatches});

  @override
  List<Object?> get props => [liveMatches];
}

class MatchDetailsLoaded extends MatchesState {
  final Match match;

  MatchDetailsLoaded({required this.match});

  @override
  List<Object?> get props => [match];
}

class MatchesFailure extends MatchesState {
  final String message;

  MatchesFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final ApiService apiService;
  Timer? _liveUpdatesTimer;
  StreamSubscription? _matchUpdatesSubscription;

  MatchesBloc({required this.apiService}) : super(MatchesInitial()) {
    on<LoadMatchesEvent>(_onLoadMatches);
    on<LoadLiveMatchesEvent>(_onLoadLiveMatches);
    on<LoadMatchDetailsEvent>(_onLoadMatchDetails);
    on<StartMatchUpdatesEvent>(_onStartMatchUpdates);
    on<StopMatchUpdatesEvent>(_onStopMatchUpdates);
  }

  void _onLoadMatches(LoadMatchesEvent event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    try {
      final matches = await apiService.getMatches(
        date: event.date,
        leagueId: event.leagueId,
        teamId: event.teamId,
      );
      emit(MatchesLoaded(
        matches: matches,
        date: event.date,
        leagueId: event.leagueId,
        teamId: event.teamId,
      ));
    } catch (e) {
      emit(MatchesFailure(message: 'Failed to load matches: ${e.toString()}'));
    }
  }

  void _onLoadLiveMatches(LoadLiveMatchesEvent event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    try {
      final liveMatches = await apiService.getLiveMatches();
      emit(LiveMatchesLoaded(liveMatches: liveMatches));
      
      // Setup periodic updates for live matches
      _liveUpdatesTimer?.cancel();
      _liveUpdatesTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        add(LoadLiveMatchesEvent());
      });
    } catch (e) {
      emit(MatchesFailure(message: 'Failed to load live matches: ${e.toString()}'));
    }
  }

  void _onLoadMatchDetails(
      LoadMatchDetailsEvent event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    try {
      final match = await apiService.getMatchDetails(event.matchId);
      emit(MatchDetailsLoaded(match: match));
    } catch (e) {
      emit(MatchesFailure(message: 'Failed to load match details: ${e.toString()}'));
    }
  }

  void _onStartMatchUpdates(
      StartMatchUpdatesEvent event, Emitter<MatchesState> emit) async {
    _matchUpdatesSubscription?.cancel();
    _matchUpdatesSubscription = apiService.getMatchUpdatesStream(event.matchId).listen(
      (match) {
        emit(MatchDetailsLoaded(match: match));
      },
      onError: (error) {
        emit(MatchesFailure(message: 'Match updates error: ${error.toString()}'));
      },
    );
  }

  void _onStopMatchUpdates(
      StopMatchUpdatesEvent event, Emitter<MatchesState> emit) {
    _matchUpdatesSubscription?.cancel();
    _matchUpdatesSubscription = null;
  }

  @override
  Future<void> close() {
    _liveUpdatesTimer?.cancel();
    _matchUpdatesSubscription?.cancel();
    return super.close();
  }
}
