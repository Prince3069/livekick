// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:livekick/widgets/featured_match_card.dart';
// import 'package:livekick/widgets/news_card.dart';
// import 'package:livekick/widgets/league_selector.dart';
// import 'package:livekick/models/match.dart';
// import 'package:livekick/models/news.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Match> featuredMatches = [
//     Match(
//       id: '1',
//       homeTeam: 'Arsenal',
//       awayTeam: 'Chelsea',
//       homeScore: 2,
//       awayScore: 1,
//       time: '75\'',
//       leagueName: 'Premier League',
//       isLive: true,
//       matchDate: DateTime.now(),
//     ),
//     Match(
//       id: '2',
//       homeTeam: 'Barcelona',
//       awayTeam: 'Real Madrid',
//       homeScore: 0,
//       awayScore: 0,
//       time: 'Today, 20:45',
//       leagueName: 'La Liga',
//       isLive: false,
//       matchDate: DateTime.now().add(Duration(hours: 2)),
//     ),
//   ];

//   final List<News> latestNews = [
//     News(
//       id: '1',
//       title: 'Messi scores hat-trick in Champions League',
//       imageUrl: 'https://via.placeholder.com/300',
//       publishedAt: DateTime.now().subtract(Duration(hours: 3)),
//     ),
//     News(
//       id: '2',
//       title: 'Premier League announces new broadcasting deal',
//       imageUrl: 'https://via.placeholder.com/300',
//       publishedAt: DateTime.now().subtract(Duration(hours: 6)),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('LiveKick', style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // TODO: Implement search functionality
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {
//               // TODO: Implement notifications screen
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // TODO: Implement refresh functionality
//           await Future.delayed(Duration(seconds: 1));
//         },
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               LeagueSelector(),
//               SizedBox(height: 16),
//               Text(
//                 'Live & Upcoming Matches',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               SizedBox(height: 8),
//               SizedBox(
//                 height: 180,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: featuredMatches.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.only(right: 12),
//                       child: FeaturedMatchCard(match: featuredMatches[index]),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Latest News',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // TODO: Navigate to all news screen
//                     },
//                     child: Text('See All'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: latestNews.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 12),
//                     child: NewsCard(news: latestNews[index]),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:livekick/widgets/featured_match_card.dart';
import 'package:livekick/widgets/news_card.dart';
import 'package:livekick/widgets/league_selector.dart';
import 'package:livekick/models/match.dart';
import 'package:livekick/models/news.dart';
import 'package:livekick/screens/odds_screen.dart';

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
              LeagueSelector(
                leagues: [],
                selectedLeagueId: null,
                onLeagueSelected: (int) {},
              ),
              SizedBox(height: 16),

              // Quick actions section
              _buildQuickActionsSection(context),
              SizedBox(height: 24),

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

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Access', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickActionCard(
                context,
                title: 'Match Odds',
                icon: Icons.attach_money,
                color: Colors.green.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OddsScreen()),
                  );
                },
              ),
              SizedBox(width: 12),
              _buildQuickActionCard(
                context,
                title: 'Live Matches',
                icon: Icons.live_tv,
                color: Colors.red.shade700,
                onTap: () {
                  // Navigate to live matches
                },
              ),
              SizedBox(width: 12),
              _buildQuickActionCard(
                context,
                title: 'Fixtures',
                icon: Icons.calendar_today,
                color: Colors.blue.shade700,
                onTap: () {
                  // Navigate to fixtures
                },
              ),
              SizedBox(width: 12),
              _buildQuickActionCard(
                context,
                title: 'Leagues',
                icon: Icons.emoji_events,
                color: Colors.amber.shade700,
                onTap: () {
                  // Navigate to leagues
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
