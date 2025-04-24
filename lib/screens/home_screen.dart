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

// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:livekick/widgets/featured_match_card.dart';
// import 'package:livekick/widgets/news_card.dart';
// import 'package:livekick/widgets/league_selector.dart';
// import 'package:livekick/models/match.dart';
// import 'package:livekick/models/news.dart';
// import 'package:livekick/screens/odds_screen.dart';

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
//               LeagueSelector(
//                 leagues: [],
//                 selectedLeagueId: -1,
//                 onLeagueSelected: (int) {},
//               ),
//               SizedBox(height: 16),

//               // Quick actions section
//               _buildQuickActionsSection(context),
//               SizedBox(height: 24),

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

//   Widget _buildQuickActionsSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Quick Access', style: Theme.of(context).textTheme.titleLarge),
//         SizedBox(height: 12),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               _buildQuickActionCard(
//                 context,
//                 title: 'Match Odds',
//                 icon: Icons.attach_money,
//                 color: Colors.green.shade700,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => OddsScreen()),
//                   );
//                 },
//               ),
//               SizedBox(width: 12),
//               _buildQuickActionCard(
//                 context,
//                 title: 'Live Matches',
//                 icon: Icons.live_tv,
//                 color: Colors.red.shade700,
//                 onTap: () {
//                   // Navigate to live matches
//                 },
//               ),
//               SizedBox(width: 12),
//               _buildQuickActionCard(
//                 context,
//                 title: 'Fixtures',
//                 icon: Icons.calendar_today,
//                 color: Colors.blue.shade700,
//                 onTap: () {
//                   // Navigate to fixtures
//                 },
//               ),
//               SizedBox(width: 12),
//               _buildQuickActionCard(
//                 context,
//                 title: 'Leagues',
//                 icon: Icons.emoji_events,
//                 color: Colors.amber.shade700,
//                 onTap: () {
//                   // Navigate to leagues
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionCard(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 110,
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.3), width: 1),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: color, size: 24),
//             ),
//             SizedBox(height: 8),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.w500, color: color),
//             ),
//           ],
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
import 'package:livekick/models/odds.dart';
import 'package:livekick/screens/odds_screen.dart';
import 'package:livekick/screens/live_screen.dart';
import 'package:livekick/screens/matches_screen.dart';
import 'package:livekick/screens/leagues_screen.dart';
import 'package:livekick/screens/news_list_screen.dart';
import 'package:livekick/repositories/match_repository.dart';
import 'package:livekick/repositories/news_repository.dart';
import 'package:livekick/repositories/league_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MatchRepository _matchRepository = MatchRepository();
  final NewsRepository _newsRepository = NewsRepository();
  final LeagueRepository _leagueRepository = LeagueRepository();

  bool _isLoadingMatches = false;
  bool _isLoadingNews = false;
  bool _isLoadingLeagues = false;

  String? _matchError;
  String? _newsError;

  List<Match> _featuredMatches = [];
  List<News> _latestNews = [];
  List<LeagueInfo> _leagues = [];
  int _selectedLeagueId = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadLeagues();
    _loadFeaturedMatches();
    _loadLatestNews();
  }

  Future<void> _loadLeagues() async {
    setState(() {
      _isLoadingLeagues = true;
    });

    try {
      final leagues = await _leagueRepository.getLeagues();
      setState(() {
        _leagues = leagues;
        _isLoadingLeagues = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLeagues = false;
      });
      print('Error loading leagues: $e');
    }
  }

  Future<void> _loadFeaturedMatches() async {
    setState(() {
      _isLoadingMatches = true;
      _matchError = null;
    });

    try {
      final matches = await _matchRepository.getFeaturedMatches();
      setState(() {
        _featuredMatches = matches;
        _isLoadingMatches = false;
      });
    } catch (e) {
      setState(() {
        _matchError = e.toString();
        _isLoadingMatches = false;
      });
    }
  }

  Future<void> _loadLatestNews() async {
    setState(() {
      _isLoadingNews = true;
      _newsError = null;
    });

    try {
      final news = await _newsRepository.getLatestNews();
      setState(() {
        _latestNews = news;
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        _newsError = e.toString();
        _isLoadingNews = false;
      });
    }
  }

  void _onLeagueSelected(int leagueId) {
    setState(() {
      _selectedLeagueId = leagueId;
    });
    // In a real app, you might want to filter content based on selected league
    _loadFeaturedMatches();
  }

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Search functionality coming soon')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeagueSelector(),
              SizedBox(height: 16),

              // Quick actions section
              _buildQuickActionsSection(context),
              SizedBox(height: 24),

              _buildFeaturedMatchesSection(),
              SizedBox(height: 24),

              _buildLatestNewsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeagueSelector() {
    if (_isLoadingLeagues) {
      return Center(
        child: Container(height: 50, child: CircularProgressIndicator()),
      );
    }

    return LeagueSelector(
      leagues: _leagues,
      selectedLeagueId: _selectedLeagueId,
      onLeagueSelected: _onLeagueSelected,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LiveScreen()),
                  );
                },
              ),
              SizedBox(width: 12),
              _buildQuickActionCard(
                context,
                title: 'Fixtures',
                icon: Icons.calendar_today,
                color: Colors.blue.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MatchesScreen()),
                  );
                },
              ),
              SizedBox(width: 12),
              _buildQuickActionCard(
                context,
                title: 'Leagues',
                icon: Icons.emoji_events,
                color: Colors.amber.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaguesScreen()),
                  );
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
        height: 100, // Fixed height to prevent overflow
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
            Flexible(
              // Added Flexible to handle overflow
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live & Upcoming Matches',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8),

        _isLoadingMatches
            ? Container(
              height: 180,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
            : _matchError != null
            ? Container(
              height: 180,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(height: 8),
                  Text('Failed to load matches'),
                  TextButton(
                    onPressed: _loadFeaturedMatches,
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
            : _featuredMatches.isEmpty
            ? Container(
              height: 180,
              alignment: Alignment.center,
              child: Text('No matches available'),
            )
            : SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _featuredMatches.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: FeaturedMatchCard(match: _featuredMatches[index]),
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget _buildLatestNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Latest News', style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsListScreen()),
                );
              },
              child: Text('See All'),
            ),
          ],
        ),
        SizedBox(height: 8),

        _isLoadingNews
            ? Container(
              height: 200,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
            : _newsError != null
            ? Container(
              height: 200,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(height: 8),
                  Text('Failed to load news'),
                  TextButton(onPressed: _loadLatestNews, child: Text('Retry')),
                ],
              ),
            )
            : _latestNews.isEmpty
            ? Container(
              height: 200,
              alignment: Alignment.center,
              child: Text('No news available'),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:
                  _latestNews.length > 2
                      ? 2
                      : _latestNews.length, // Limit to 2 items
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: NewsCard(news: _latestNews[index]),
                );
              },
            ),
      ],
    );
  }
}
