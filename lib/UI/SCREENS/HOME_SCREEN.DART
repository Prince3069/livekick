// ===============================
// UI/SCREENS/HOME_SCREEN.DART
// ===============================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekick/core/blocs/matches/matches_bloc.dart';
import 'package:livekick/core/blocs/auth/auth_bloc.dart';
import 'package:livekick/ui/widgets/live_match_card.dart';
import 'package:livekick/ui/widgets/match_list_item.dart';
import 'package:livekick/ui/widgets/date_selector.dart';
import 'package:livekick/ui/screens/highlights_screen.dart';
import 'package:livekick/ui/screens/stats_screen.dart';
import 'package:livekick/ui/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Load live matches on startup
    context.read<MatchesBloc>().add(LoadLiveMatchesEvent());
    
    // Load today's matches
    context.read<MatchesBloc>().add(
      LoadMatchesEvent(date: _selectedDate),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    context.read<MatchesBloc>().add(
      LoadMatchesEvent(date: date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveKick'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications screen
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Matches Tab
          _buildMatchesTab(),
          
          // Highlights Tab
          const HighlightsScreen(),
          
          // Stats Tab
          const StatsScreen(),
          
          // Profile Tab
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Highlights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MatchesBloc>().add(LoadLiveMatchesEvent());
        context.read<MatchesBloc>().add(
          LoadMatchesEvent(date: _selectedDate),
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Matches Section
            _buildLiveMatchesSection(),
            
            // Date Selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: _onDateSelected,
              ),
            ),
            
            // Matches by Date Section
            _buildMatchesByDateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all live matches
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: BlocBuilder<MatchesBloc, MatchesState>(
            builder: (context, state) {
              if (state is LiveMatchesLoaded) {
                if (state.liveMatches.isEmpty) {
                  return const Center(
                    child: Text('No live matches at the moment'),
                  );
                }
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.liveMatches.length,
                  itemBuilder: (context, index) {
                    return LiveMatchCard(
                      match: state.liveMatches[index],
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.matchDetail,
                          arguments: {'matchId': state.liveMatches[index].id},
                        );
                      },
                    );
                  },
                );
              } else if (state is MatchesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MatchesFailure) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }
              
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchesByDateSection() {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is MatchesLoaded) {
          if (state.matches.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Text('No matches on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              ),
            );
          }
          
          // Group matches by league
          final groupedMatches = <String, List<dynamic>>{};
          for (final match in state.matches) {
            if (!groupedMatches.containsKey(match.leagueId)) {
              groupedMatches[match.leagueId] = [];
            }
            groupedMatches[match.leagueId]!.add({
              'name': match.leagueName,
              'match': match,
            });
          }
          
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: groupedMatches.length,
            itemBuilder: (context, index) {
              final leagueId = groupedMatches.keys.elementAt(index);
              final matches = groupedMatches[leagueId]!;
              final leagueName = matches.first['name'];
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      leagueName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: matches.length,
                    itemBuilder: (context, idx) {
                      return MatchListItem(
                        match: matches[idx]['match'],
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.matchDetail,
                            arguments: {'matchId': matches[idx]['match'].id},
                          );
                        },
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          );
        } else if (state is MatchesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MatchesFailure) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
