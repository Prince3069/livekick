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
      items:
          leagues.map((league) {
            return DropdownMenuItem<int>(
              value: league.id,
              child: Text('${league.name} (${league.country})'),
            );
          }).toList(),
    );
  }
}
