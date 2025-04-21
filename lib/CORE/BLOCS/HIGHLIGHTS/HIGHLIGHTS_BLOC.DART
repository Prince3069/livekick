
// ===============================
// CORE/BLOCS/HIGHLIGHTS/HIGHLIGHTS_BLOC.DART
// ===============================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekick/core/models/highlight_model.dart';
import 'package:livekick/core/services/api_service.dart';

// Events
abstract class HighlightsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHighlightsEvent extends HighlightsEvent {
  final String? matchId;
  final String? teamId;
  final int page;
  final int limit;

  LoadHighlightsEvent({
    this.matchId,
    this.teamId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [matchId, teamId, page, limit];
}

class LoadHighlightDetailsEvent extends HighlightsEvent {
  final String highlightId;

  LoadHighlightDetailsEvent({required this.highlightId});

  @override
  List<Object?> get props => [highlightId];
}

class IncreaseHighlightViewsEvent extends HighlightsEvent {
  final String highlightId;

  IncreaseHighlightViewsEvent({required this.highlightId});

  @override
  List<Object?> get props => [highlightId];
}

// States
abstract class HighlightsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HighlightsInitial extends HighlightsState {}

class HighlightsLoading extends HighlightsState {}

class HighlightsLoaded extends HighlightsState {
  final List<Highlight> highlights;
  final bool hasMorePages;
  final int currentPage;
  final String? matchId;
  final String? teamId;

  HighlightsLoaded({
    required this.highlights,
    required this.hasMorePages,
    required this.currentPage,
    this.matchId,
    this.teamId,
  });

  @override
  List<Object?> get props => [highlights, hasMorePages, currentPage, matchId, teamId];
}

class HighlightDetailsLoaded extends HighlightsState {
  final Highlight highlight;

  HighlightDetailsLoaded({required this.highlight});

  @override
  List<Object?> get props => [highlight];
}

class HighlightsFailure extends HighlightsState {
  final String message;

  HighlightsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class HighlightsBloc extends Bloc<HighlightsEvent, HighlightsState> {
  final ApiService apiService;

  HighlightsBloc({required this.apiService}) : super(HighlightsInitial()) {
    on<LoadHighlightsEvent>(_onLoadHighlights);
    on<LoadHighlightDetailsEvent>(_onLoadHighlightDetails);
    on<IncreaseHighlightViewsEvent>(_onIncreaseHighlightViews);
  }

  void _onLoadHighlights(LoadHighlightsEvent event, Emitter<HighlightsState> emit) async {
    final currentState = state;
    List<Highlight> existingHighlights = [];
    
    if (currentState is HighlightsLoaded && 
        event.page > 1 && 
        currentState.matchId == event.matchId && 
        currentState.teamId == event.teamId) {
      existingHighlights = List.from(currentState.highlights);
      emit(HighlightsLoading());
    } else {
      emit(HighlightsLoading());
    }

    try {
      final result = await apiService.getHighlights(
        matchId: event.matchId,
        teamId: event.teamId,
        page: event.page,
        limit: event.limit,
      );
      
      if (event.page > 1) {
        // Append new data to existing data
        emit(HighlightsLoaded(
          highlights: [...existingHighlights, ...result.highlights],
          hasMorePages: result.hasMorePages,
          currentPage: event.page,
          matchId: event.matchId,
          teamId: event.teamId,
        ));
      } else {
        // First page, replace existing data
        emit(HighlightsLoaded(
          highlights: result.highlights,
          hasMorePages: result.hasMorePages,
          currentPage: event.page,
          matchId: event.matchId,
          teamId: event.teamId,
        ));
      }
    } catch (e) {
      emit(HighlightsFailure(message: 'Failed to load highlights: ${e.toString()}'));
    }
  }

  void _onLoadHighlightDetails(
      LoadHighlightDetailsEvent event, Emitter<HighlightsState> emit) async {
    emit(HighlightsLoading());
    try {
      final highlight = await apiService.getHighlightDetails(event.highlightId);
      emit(HighlightDetailsLoaded(highlight: highlight));
    } catch (e) {
      emit(HighlightsFailure(message: 'Failed to load highlight details: ${e.toString()}'));
    }
  }

  void _onIncreaseHighlightViews(
      IncreaseHighlightViewsEvent event, Emitter<HighlightsState> emit) async {
    try {
      await apiService.increaseHighlightViews(event.highlightId);
      
      // Update the view count in current state if possible
      final currentState = state;
      if (currentState is HighlightDetailsLoaded && 
          currentState.highlight.id == event.highlightId) {
        final updatedHighlight = currentState.highlight.copyWith(
          views: currentState.highlight.views + 1,
        );
        emit(HighlightDetailsLoaded(highlight: updatedHighlight));
      } else if (currentState is HighlightsLoaded) {
        final index = currentState.highlights.indexWhere((h) => h.id == event.highlightId);
        if (index != -1) {
          final updatedHighlights = List<Highlight>.from(currentState.highlights);
          updatedHighlights[index] = updatedHighlights[index].copyWith(
            views: updatedHighlights[index].views + 1,
          );
          emit(HighlightsLoaded(
            highlights: updatedHighlights,
            hasMorePages: currentState.hasMorePages,
            currentPage: currentState.currentPage,
            matchId: currentState.matchId,
            teamId: currentState.teamId,
          ));
        }
      }
    } catch (e) {
      // Don't emit failure for view count - just log
      print('Failed to update highlight views: ${e.toString()}');
    }
  }
}
