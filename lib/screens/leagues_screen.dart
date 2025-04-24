import 'package:flutter/material.dart';
import 'package:livekick/models/odds.dart';
import 'package:livekick/repositories/league_repository.dart';

class LeaguesScreen extends StatefulWidget {
  @override
  _LeaguesScreenState createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final LeagueRepository _repository = LeagueRepository();

  bool _isLoading = true;
  String? _error;
  List<LeagueInfo> _leagues = [];

  @override
  void initState() {
    super.initState();
    _loadLeagues();
  }

  Future<void> _loadLeagues() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final leagues = await _repository.getLeagues();
      leagues.sort((a, b) => a.country.compareTo(b.country));

      setState(() {
        _leagues = leagues;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Leagues")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Leagues")),
        body: Center(child: Text('Error: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Leagues")),
      body: ListView.builder(
        itemCount: _leagues.length,
        itemBuilder: (context, index) {
          final league = _leagues[index];
          return ListTile(
            leading: Icon(Icons.sports_soccer, color: Colors.blue),
            title: Text(league.name),
            subtitle: Text(league.country),
            onTap: () {
              // Navigate to matches screen or league details
              // Navigator.push(context, MaterialPageRoute(builder: (_) => MatchesScreen(league: league)));
            },
          );
        },
      ),
    );
  }
}
