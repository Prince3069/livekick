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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
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
            children:
                bet.odds.map((odd) {
                  return Expanded(
                    child: Card(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(odd.value, style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text(
                              odd.odd,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color:
                                    Theme.of(
                                      brightness: Brightness.light,
                                    ).primaryColor,
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
