
// ===============================
// UI/SCREENS/MATCH_DETAIL_SCREEN.DART
// ===============================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekick/config/routes.dart';
import 'package:livekick/core/blocs/matches/matches_bloc.dart';
import 'package:livekick/core/blocs/stats/stats_bloc.dart';
import 'package:livekick/core/blocs/highlights/highlights_bloc.dart';
import 'package:livekick/core/models/match_model.dart';
import 'package:livekick/ui/widgets/match_header.dart';
import 'package:livekick/ui/widgets/match_stats_view.dart';
import 'package:livekick/ui/widgets/match_timeline.dart';
import 'package:livekick/ui/widgets/highlight_list_item.dart';

class MatchDetailScreen extends StatefulWidget {
  final String matchId;

  const MatchDetailScreen({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load match details
    context.read<MatchesBloc>().add(
      LoadMatchDetailsEvent(matchId: widget.matchId),
    );
    
    // Load match stats
    context.read<StatsBloc>().add(
      LoadMatchStatsEvent(matchId: widget.matchId),
    );
    
    // Load match highlights
    context.read<HighlightsBloc>().add(
      LoadHighlightsEvent(matchId: widget.matchId),
    );
    
    // Start live updates if match is live
    context.read<MatchesBloc>().add(
      StartMatchUpdatesEvent(matchId: widget.matchId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    context.read<MatchesBloc>().add(StopMatchUpdatesEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MatchesBloc, MatchesState>(
          builder: (context, state) {
            if (state is MatchDetailsLoaded) {
              return Text('${state.match.homeTeamName} vs ${state.match.awayTeamName}');
            }
            return const Text('Match Details');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // TODO: Implement favorite functionality
            },
          ),
        ],
      ),
      body: BlocBuilder<MatchesBloc, MatchesState>(
        builder: (context, state) {
          if (state is MatchDetailsLoaded) {
            return _buildContent(state.match);
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
    );
  }

  Widget _buildContent(Match match) {
    return Column(
      children: [
        // Match Header
        MatchHeader(match: match),
        
        // Stream button if live
        if (match.isLive && match.streamUrl != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.live_tv),
              label: const Text('Watch Live Stream'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                // TODO: Implement video player for live stream
              },
            ),
          ),
        
        // Tab Bar
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Stats'),
            Tab(text: 'Highlights'),
          ],
        ),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Match Info Tab
              _buildInfoTab(match),
              
              // Stats Tab
              _buildStatsTab(),
              
              // Highlights Tab
              _buildHighlightsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(Match match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow('Stadium', match.stadium ?? 'N/A'),
                  const Divider(),
                  _buildInfoRow('Referee', match.referee ?? 'N/A'),
                  const Divider(),
                  _buildInfoRow(
                    'Date & Time',
                    '${match.dateTime.day}/${match.dateTime.month}/${match.dateTime.year} ${match.dateTime.hour}:${match.dateTime.minute.toString().padLeft(2, '0')}',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Status',
                    match.isLive 
                        ? 'Live - ${match.minute}′' 
                        : match.isFinished 
                            ? 'Finished' 
                            : 'Scheduled',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Match Timeline
          const Text(
            'Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          
          BlocBuilder<StatsBloc, StatsState>(
            builder: (context, state) {
              if (state is MatchStatsLoaded) {
                return MatchTimeline(events: state.stats.events);
              } else if (state is StatsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StatsFailure) {
                return Center(
                  child: Text('Failed to load timeline: ${state.message}'),
                );
              }
              
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is MatchStatsLoaded) {
          return MatchStatsView(stats: state.stats);
        } else if (state is StatsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is StatsFailure) {
          return Center(
            child: Text('Failed to load stats: ${state.message}'),
          );
        }
        
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildHighlightsTab() {
    return BlocBuilder<HighlightsBloc, HighlightsState>(
      builder: (context, state) {
        if (state is HighlightsLoaded) {
          if (state.highlights.isEmpty) {
            return const Center(
              child: Text('No highlights available yet'),
            );
          }
          
          return ListView.builder(
            itemCount: state.highlights.length,
            itemBuilder: (context, index) {
              return HighlightListItem(
                highlight: state.highlights[index],
                onTap: () {
                  // Navigate to highlight details
                  Navigator.of(context).pushNamed(
                    AppRoutes.highlights,
                    arguments: {'highlightId': state.highlights[index].id},
                  );
                  
                  // Increase view count
                  context.read<HighlightsBloc>().add(
                    IncreaseHighlightViewsEvent(
                      highlightId: state.highlights[index].id,
                    ),
                  );
                },
              );
            },
          );
        } else if (state is HighlightsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HighlightsFailure) {
          return Center(
            child: Text('Failed to load highlights: ${state.message}'),
          );
        }
        
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
