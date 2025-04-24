// lib/screens/odds_screen.dart
import 'package:flutter/material.dart';
import 'package:livekick/models/odds.dart';
import 'package:livekick/repositories/odds_repository.dart';
import 'package:livekick/widgets/bookmaker_dropdown.dart';
import 'package:livekick/widgets/league_selector.dart';
import 'package:livekick/widgets/match_odds_card.dart';
import 'package:intl/intl.dart';

class OddsScreen extends StatefulWidget {
  @override
  _OddsScreenState createState() => _OddsScreenState();
}

class _OddsScreenState extends State<OddsScreen> {
  final OddsRepository _repository = OddsRepository();

  bool _isLoading = false;
  String? _error;

  // Selected filters
  int _selectedLeagueId = 0;
  String? _selectedBookmaker;

  // Data
  List<LeagueInfo> _leagues = [];
  List<Bookmaker> _bookmakers = [];
  OddsResponse? _oddsResponse;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load leagues and bookmakers
      final leagues = await _repository.getLeagues();
      final bookmakers = await _repository.getBookmakers();

      setState(() {
        _leagues = leagues;
        _bookmakers = bookmakers;

        // Set default league if available
        if (leagues.isNotEmpty) {
          _selectedLeagueId = leagues.first.id;
        }
      });

      // Load initial odds if we have a league selected
      if (_selectedLeagueId > 0) {
        _loadOdds();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadOdds() async {
    if (_selectedLeagueId <= 0) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final oddsResponse = await _repository.getOddsForLeague(
        _selectedLeagueId,
        bookmaker: _selectedBookmaker,
      );

      setState(() {
        _oddsResponse = oddsResponse;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onLeagueSelected(int leagueId) {
    setState(() {
      _selectedLeagueId = leagueId;
    });
    _loadOdds();
  }

  void _onBookmakerSelected(String? bookmaker) {
    setState(() {
      _selectedBookmaker = bookmaker;
    });
    _loadOdds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match Odds')),
      body: Column(
        children: [
          // Filters section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LeagueSelector(
                        leagues: _leagues,
                        selectedLeagueId: _selectedLeagueId,
                        onLeagueSelected: _onLeagueSelected,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: BookmakerDropdown(
                        bookmakers: _bookmakers,
                        selectedBookmaker: _selectedBookmaker,
                        onBookmakerSelected: _onBookmakerSelected,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content section
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text('Error: $_error'),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _loadOdds, child: Text('Try Again')),
            ],
          ),
        ),
      );
    }

    if (_oddsResponse == null || _oddsResponse!.odds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No odds available for the selected filters'),
          ],
        ),
      );
    }

    // Group odds by date for better organization
    final oddsGroupedByDate = <String, List<OddsData>>{};
    for (final odd in _oddsResponse!.odds) {
      final dateKey = DateFormat('yyyy-MM-dd').format(odd.fixture.date);
      if (!oddsGroupedByDate.containsKey(dateKey)) {
        oddsGroupedByDate[dateKey] = [];
      }
      oddsGroupedByDate[dateKey]!.add(odd);
    }

    final sortedDates = oddsGroupedByDate.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final matchesForDate = oddsGroupedByDate[dateKey]!;
        final date = DateTime.parse(dateKey);
        final formattedDate = DateFormat('EEEE, MMM d').format(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                formattedDate,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...matchesForDate
                .map((odd) => MatchOddsCard(oddsData: odd))
                .toList(),
          ],
        );
      },
    );
  }
}
