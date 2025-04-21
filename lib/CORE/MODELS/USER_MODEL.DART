
// ===============================
// CORE/MODELS/USER_MODEL.DART
// ===============================

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final List<String> favoriteTeams;
  final List<String> favoriteLeagues;
  final bool isPremium;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.favoriteTeams = const [],
    this.favoriteLeagues = const [],
    this.isPremium = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String?,
      favoriteTeams: List<String>.from(json['favoriteTeams'] ?? []),
      favoriteLeagues: List<String>.from(json['favoriteLeagues'] ?? []),
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'favoriteTeams': favoriteTeams,
      'favoriteLeagues': favoriteLeagues,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
    List<String>? favoriteTeams,
    List<String>? favoriteLeagues,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      favoriteTeams: favoriteTeams ?? this.favoriteTeams,
      favoriteLeagues: favoriteLeagues ?? this.favoriteLeagues,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        profilePicture,
        favoriteTeams,
        favoriteLeagues,
        isPremium,
        createdAt,
      ];
}