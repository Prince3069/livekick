// lib/widgets/featured_match_card.dart
import 'package:flutter/material.dart';
import 'package:livekick/models/match.dart';

class FeaturedMatchCard extends StatelessWidget {
  final Match match;

  const FeaturedMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 280,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: match.isLive ? Colors.red : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    match.isLive ? 'LIVE' : 'UPCOMING',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  match.leagueName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(child: Text(match.homeTeam.substring(0, 1))),
                      SizedBox(height: 8),
                      Text(
                        match.homeTeam,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (match.isLive)
                      Text(
                        '${match.homeScore} - ${match.awayScore}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            match.isLive ? Colors.green[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        match.time,
                        style: TextStyle(
                          color:
                              match.isLive
                                  ? Colors.green[800]
                                  : Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(child: Text(match.awayTeam.substring(0, 1))),
                      SizedBox(height: 8),
                      Text(
                        match.awayTeam,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (match.isLive)
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to live match
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text('Watch Live'),
              )
            else
              OutlinedButton(
                onPressed: () {
                  // TODO: Set reminder for match
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text('Set Reminder'),
              ),
          ],
        ),
      ),
    );
  }
}
