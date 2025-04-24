// lib/models/league.dart

class LeagueInfo {
  final String id;
  final String name;
  final String country;

  // Constructor
  LeagueInfo({required this.id, required this.name, required this.country});

  // Factory method to create an instance of LeagueInfo from a JSON object
  factory LeagueInfo.fromJson(Map<String, dynamic> json) {
    return LeagueInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
    );
  }

  // Method to convert LeagueInfo instance to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'country': country};
  }
}
