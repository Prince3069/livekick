// lib/models/odds.dart
class OddsResponse {
  final List<OddsData> odds;
  final int resultsCount;
  final int page;
  final bool hasMore;

  OddsResponse({
    required this.odds,
    required this.resultsCount,
    required this.page,
    required this.hasMore,
  });

  factory OddsResponse.fromJson(Map<String, dynamic> json) {
    final api = json['api'] ?? {};
    final results = api['results'] ?? 0;
    final paging = api['paging'] ?? {};
    final List<dynamic> odds = api['odds'] ?? [];

    return OddsResponse(
      odds: odds.map((o) => OddsData.fromJson(o)).toList(),
      resultsCount: results,
      page: paging['current'] ?? 1,
      hasMore: paging['total'] > paging['current'],
    );
  }
}

class OddsData {
  final int fixtureId;
  final String leagueName;
  final String countryName;
  final DateTime updateDate;
  final List<BookmakerOdds> bookmakers;
  final FixtureInfo fixture;

  OddsData({
    required this.fixtureId,
    required this.leagueName,
    required this.countryName,
    required this.updateDate,
    required this.bookmakers,
    required this.fixture,
  });

  factory OddsData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> bookmakers = json['bookmakers'] ?? [];
    return OddsData(
      fixtureId: json['fixture_id'] ?? 0,
      leagueName: json['league']['name'] ?? '',
      countryName: json['league']['country'] ?? '',
      updateDate: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      bookmakers: bookmakers.map((b) => BookmakerOdds.fromJson(b)).toList(),
      fixture: FixtureInfo.fromJson(json['fixture'] ?? {}),
    );
  }
}

class FixtureInfo {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final DateTime date;
  final String status;

  FixtureInfo({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.status,
  });

  factory FixtureInfo.fromJson(Map<String, dynamic> json) {
    return FixtureInfo(
      id: json['fixture_id'] ?? 0,
      homeTeam: json['homeTeam'] ?? '',
      awayTeam: json['awayTeam'] ?? '',
      date: DateTime.parse(
        json['event_date'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? '',
    );
  }
}

class BookmakerOdds {
  final int bookmakerId;
  final String bookmakerName;
  final List<BetOdds> bets;

  BookmakerOdds({
    required this.bookmakerId,
    required this.bookmakerName,
    required this.bets,
  });

  factory BookmakerOdds.fromJson(Map<String, dynamic> json) {
    final List<dynamic> bets = json['bets'] ?? [];
    return BookmakerOdds(
      bookmakerId: json['bookmaker_id'] ?? 0,
      bookmakerName: json['bookmaker_name'] ?? '',
      bets: bets.map((b) => BetOdds.fromJson(b)).toList(),
    );
  }
}

class BetOdds {
  final int betId;
  final String betName;
  final List<Odd> odds;

  BetOdds({required this.betId, required this.betName, required this.odds});

  factory BetOdds.fromJson(Map<String, dynamic> json) {
    final List<dynamic> odds = json['values'] ?? [];
    return BetOdds(
      betId: json['label_id'] ?? 0,
      betName: json['label_name'] ?? '',
      odds: odds.map((o) => Odd.fromJson(o)).toList(),
    );
  }
}

class Odd {
  final String value;
  final String odd;

  Odd({required this.value, required this.odd});

  factory Odd.fromJson(Map<String, dynamic> json) {
    return Odd(value: json['value'] ?? '', odd: json['odd'] ?? '');
  }
}

class Bookmaker {
  final int id;
  final String name;

  Bookmaker({required this.id, required this.name});

  factory Bookmaker.fromJson(Map<String, dynamic> json) {
    return Bookmaker(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class LeagueInfo {
  final int id;
  final String name;
  final String country;

  LeagueInfo({required this.id, required this.name, required this.country});

  factory LeagueInfo.fromJson(Map<String, dynamic> json) {
    return LeagueInfo(
      id: json['league_id'] ?? 0,
      name: json['name'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
