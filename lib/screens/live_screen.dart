// lib/screens/live_screen.dart
import 'package:flutter/material.dart';
import 'package:livekick/widgets/live_match_view.dart';
import 'package:livekick/widgets/chat_section.dart';
import 'package:livekick/models/match.dart';

class LiveScreen extends StatefulWidget {
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  bool _isFullscreen = false;

  // Mock active match data
  final Match activeMatch = Match(
    id: '1',
    homeTeam: 'Arsenal',
    awayTeam: 'Chelsea',
    homeScore: 2,
    awayScore: 1,
    time: '75\'',
    leagueName: 'Premier League',
    isLive: true,
    matchDate: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _isFullscreen
              ? null
              : AppBar(
                title: Text('Live Stream'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.fullscreen),
                    onPressed: () {
                      setState(() {
                        _isFullscreen = true;
                      });
                    },
                  ),
                ],
              ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_isFullscreen) {
                setState(() {
                  _isFullscreen = false;
                });
              }
            },
            child: Container(
              height:
                  _isFullscreen
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height * 0.35,
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    // Placeholder for video player
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Live stream will appear here',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  if (!_isFullscreen)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LiveMatchView(match: activeMatch),
                    ),
                ],
              ),
            ),
          ),
          if (!_isFullscreen)
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      tabs: [Tab(text: 'Live Chat'), Tab(text: 'Match Stats')],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ChatSection(matchId: activeMatch.id),
                          Center(
                            child: Text('Match statistics will appear here'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
