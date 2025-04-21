// ===============================
// UI/WIDGETS/MATCH_HEADER.DART (Example of one of the widgets)
// ===============================

import 'package:flutter/material.dart';
import 'package:livekick/core/models/match_model.dart';

class MatchHeader extends StatelessWidget {
  final Match match;

  const MatchHeader({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // League name
          Text(
            match.leagueName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          
          // Teams and score
          Row(
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                      match.homeTeamLogo,
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      match.homeTeamName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: match.isLive ? Colors.red : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if (match.isLive)
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Text(
                      match.hasScore
                          ? '${match.homeScore} - ${match.awayScore}'
                          : 'vs',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (match.isLive && match.minute != null)
                      Text(
                        '${match.minute}′',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Away team
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                      match.awayTeamLogo,
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      match.awayTeamName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
