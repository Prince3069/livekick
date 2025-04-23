// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:livekick/widgets/featured_match_card.dart';
import 'package:livekick/widgets/news_card.dart';
import 'package:livekick/widgets/league_selector.dart';
import 'package:livekick/models/match.dart';
import 'package:livekick/models/news.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Match> featuredMatches = [
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
      id: '2',
      homeTeam: 'Barcelona',
      awayTeam: 'Real Madrid',
      homeScore: 0,
      awayScore: 0,
      time: 'Today, 20:45',
      leagueName: 'La Liga',
      isLive: false,
      matchDate: DateTime.now().add(Duration(hours: 2)),
    ),
  ];

  final List<News> latestNews = [
    News(
      id: '1',
      title: 'Messi scores hat-trick in Champions League',
      imageUrl: 'https://via.placeholder.com/300',
      publishedAt: DateTime.now().subtract(Duration(hours: 3)),
    ),
    News(
      id: '2',
      title: 'Premier League announces new broadcasting deal',
      imageUrl: 'https://via.placeholder.com/300',
      publishedAt: DateTime.now().subtract(Duration(hours: 6)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LiveKick', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh functionality
          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeagueSelector(),
              SizedBox(height: 16),
              Text(
                'Live & Upcoming Matches',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredMatches.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: FeaturedMatchCard(match: featuredMatches[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest News',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all news screen
                    },
                    child: Text('See All'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: latestNews.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: NewsCard(news: latestNews[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
