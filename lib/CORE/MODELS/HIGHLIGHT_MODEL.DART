
// ===============================
// CORE/MODELS/HIGHLIGHT_MODEL.DART
// ===============================

import 'package:equatable/equatable.dart';

class Highlight extends Equatable {
  final String id;
  final String matchId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final DateTime uploadDate;
  final int duration; // Duration in seconds
  final int views;
  final bool isPremium;
  final String homeTeamName;
  final String awayTeamName;
  final String? homeTeamLogo;
  final String? awayTeamLogo;

  const Highlight({
    required this.id,
    required this.matchId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.uploadDate,
    required this.duration,
    this.views = 0,
    this.isPremium = false,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamLogo,
    this.awayTeamLogo,
  });

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      duration: json['duration'] as int,
      views: json['views'] as int? ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
      homeTeamName: json['homeTeamName'] as String,
      awayTeamName: json['awayTeamName'] as String,
      homeTeamLogo: json['homeTeamLogo'] as String?,
      awayTeamLogo: json['awayTeamLogo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'uploadDate': uploadDate.toIso8601String(),
      'duration': duration,
      'views': views,
      'isPremium': isPremium,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeTeamLogo': homeTeamLogo,
      'awayTeamLogo': awayTeamLogo,
    };
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        matchId,
        title,
        description,
        thumbnailUrl,
        videoUrl,
        uploadDate,
        duration,
        views,
        isPremium,
        homeTeamName,
        awayTeamName,
        homeTeamLogo,
        awayTeamLogo,
      ];
}
