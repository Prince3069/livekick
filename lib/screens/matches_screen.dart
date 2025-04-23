// lib/screens/matches_screen.dart
import 'package:flutter/material.dart';
import 'package:livekick/widgets/match_list_item.dart';
import 'package:livekick/models/match.dart';
import 'package:intl/intl.dart';

class MatchesScreen extends StatefulWidget {
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Live', 'Today', 'Tomorrow', 'All'];

  final Map<String, List<Match>> _matchesByDay = {
    'Live': [
      Match(
        id: '1',
        homeTeam: 'Arsenal',
        awayTeam: 'Chelsea',
        homeScore: 2,
        awayScore: 1,
        time: '75\'',
        leagueName: 'Premier League',
        isLive: true,
        matchDate: DateTime.now(),
      ),
      Match(
        id: '3',
        homeTeam: 'Bayern Munich',
        awayTeam: 'Dortmund',
        homeScore: 3,
        awayScore: 2,
        time: '60\'',
        leagueName: 'Bundesliga',
        isLive: true,
        matchDate: DateTime.now(),
      ),
    ],
    'Today': [
      Match(
        id: '2',
        homeTeam: 'Barcelona',
        awayTeam: 'Real Madrid',
        homeScore: 0,
        awayScore: 0,
        time: '20:45',
        leagueName: 'La Liga',
        isLive: false,
        matchDate: DateTime.now().add(Duration(hours: 2)),
      ),
    ],
    'Tomorrow': [
      Match(
        id: '4',
        homeTeam: 'PSG',
        awayTeam: 'Marseille',
        homeScore: 0,
        awayScore: 0,
        time: '21:00',
        leagueName: 'Ligue 1',
        isLive: false,
        matchDate: DateTime.now().add(Duration(days: 1)),
      ),
    ],
    'All': [], // Will combine all matches
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // Combine all matches for "All" tab
    _matchesByDay['All'] = [
      ..._matchesByDay['Live']!,
      ..._matchesByDay['Today']!,
      ..._matchesByDay['Tomorrow']!,
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _tabs.map((tab) {
              final matches = _matchesByDay[tab] ?? [];
              return matches.isEmpty
                  ? Center(child: Text('No matches available'))
                  : ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      return MatchListItem(match: matches[index]);
                    },
                  );
            }).toList(),
      ),
    );
  }
}
