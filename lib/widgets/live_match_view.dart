// // lib/widgets/live_match_view.dart
// // ignore_for_file: prefer_const_constructors, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:livekick/models/match.dart';

// class LiveMatchView extends StatelessWidget {
//   final Match match;

//   const LiveMatchView({required this.match});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.black.withOpacity(0.6),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 match.leagueName,
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//               SizedBox(height: 4),
//               Row(
//                 children: [
//                   Text(
//                     match.homeTeam,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     ' vs ',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                   Text(
//                     match.awayTeam,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Spacer(),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${match.homeScore} - ${match.awayScore}',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               match.time,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// lib/widgets/league_selector.dart
import 'package:flutter/material.dart';
import 'package:livekick/models/odds.dart';

class LeagueSelector extends StatelessWidget {
  final List<LeagueInfo> leagues;
  final int selectedLeagueId;
  final Function(int) onLeagueSelected;

  const LeagueSelector({
    required this.leagues,
    required this.selectedLeagueId,
    required this.onLeagueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'League',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: selectedLeagueId > 0 ? selectedLeagueId : null,
      hint: Text('Select League'),
      onChanged: (value) {
        if (value != null) {
          onLeagueSelected(value);
        }
      },
      items: leagues.map((league) {
        return DropdownMenuItem<int>(
          value: league.id,
          child: Text('${league.name} (${league.country})'),
        );
      }).toList(),
    );
  }
}

// lib/widgets/bookmaker_dropdown.dart
import 'package:flutter/material.dart';
import 'package:livekick/models/odds.dart';

class BookmakerDropdown extends StatelessWidget {
  final List<Bookmaker> bookmakers;
  final String? selectedBookmaker;
  final Function(String?) onBookmakerSelected;

  const BookmakerDropdown({
    required this.bookmakers,
    required this.selectedBookmaker,
    required this.onBookmakerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Bookmaker',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: selectedBookmaker,
      hint: Text('All Bookmakers'),
      onChanged: onBookmakerSelected,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('All Bookmakers'),
        ),
        ...bookmakers.map((bookmaker) {
          return DropdownMenuItem<String>(
            value: bookmaker.id.toString(),
            child: Text(bookmaker.name),
          );
        }).toList(),
      ],
    );
  }
}

// lib/widgets/match_odds_card.dart
import 'package:flutter/material.dart';
import 'package:livekick/models/odds.dart';
import 'package:intl/intl.dart';

class MatchOddsCard extends StatelessWidget {
  final OddsData oddsData;

  const MatchOddsCard({required this.oddsData});

  @override
  Widget build(BuildContext context) {
    final fixture = oddsData.fixture;
    final time = DateFormat('HH:mm').format(fixture.date);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Match header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${oddsData.leagueName}, ${oddsData.countryName}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${fixture.homeTeam} vs ${fixture.awayTeam}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // Odds list
          if (oddsData.bookmakers.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: oddsData.bookmakers.length,
              itemBuilder: (context, index) {
                final bookmaker = oddsData.bookmakers[index];
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bookmaker header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        bookmaker.bookmakerName,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    
                    // Bets from this bookmaker
                    ...bookmaker.bets.map((bet) {
                      return _buildBetRow(bet);
                    }).toList(),
                    
                    Divider(),
                  ],
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No odds available for this match'),
            ),
        ],
      ),
    );
  }
  
  Widget _buildBetRow(BetOdds bet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bet.betName,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Row(
            children: bet.odds.map((odd) {
              return Expanded(
                child: Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          odd.value,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          odd.odd,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(brightness: Brightness.light).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}