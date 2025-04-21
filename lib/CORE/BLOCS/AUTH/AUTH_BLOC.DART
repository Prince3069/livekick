
// ===============================
// CORE/BLOCS/AUTH/AUTH_BLOC.DART
// ===============================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekick/core/models/user_model.dart';
import 'package:livekick/core/services/firebase_service.dart';
import 'package:livekick/core/services/local_storage_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthUpdateProfileEvent extends AuthEvent {
  final User updatedUser;

  AuthUpdateProfileEvent({required this.updatedUser});

  @override
  List<Object?> get props => [updatedUser];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService firebaseService;
  final LocalStorageService localStorageService;

  AuthBloc({
    required this.firebaseService,
    required this.localStorageService,
  }) : super(AuthInitial()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthUpdateProfileEvent>(_onUpdateProfile);
  }

  void _onCheckStatus(AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await localStorageService.getAuthToken();
      if (token != null) {
        final user = await firebaseService.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          await localStorageService.clearAuthToken();
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(message: 'Failed to check authentication status: ${e.toString()}'));
      emit(AuthUnauthenticated());
    }
  }

  void _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await firebaseService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await localStorageService.setAuthToken(await firebaseService.getIdToken());
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: 'Login failed: ${e.toString()}'));
      emit(AuthUnauthenticated());
    }
  }

  void _onRegister(AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await firebaseService.registerWithEmailAndPassword(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      await localStorageService.setAuthToken(await firebaseService.getIdToken());
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: 'Registration failed: ${e.toString()}'));
      emit(AuthUnauthenticated());
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await firebaseService.signOut();
      await localStorageService.clearAuthToken();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: 'Logout failed: ${e.toString()}'));
    }
  }

  void _onUpdateProfile(AuthUpdateProfileEvent event, Emitter<AuthState> emit) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(AuthLoading());
      try {
        final updatedUser = await firebaseService.updateUserProfile(event.updatedUser);
        emit(AuthAuthenticated(user: updatedUser));
      } catch (e) {
        emit(AuthFailure(message: 'Profile update failed: ${e.toString()}'));
        emit(currentState);
      }
    }
  }
}