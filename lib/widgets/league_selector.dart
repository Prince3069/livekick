// // lib/widgets/league_selector.dart
// import 'package:flutter/material.dart';

// class LeagueSelector extends StatefulWidget {
//   @override
//   _LeagueSelectorState createState() => _LeagueSelectorState();
// }

// // lib/widgets/league_selector.dart (continued)
// class _LeagueSelectorState extends State<LeagueSelector> {
//   int _selectedIndex = 0;

//   final List<Map<String, dynamic>> _leagues = [
//     {'name': 'All', 'icon': Icons.sports_soccer},
//     {'name': 'Premier League', 'icon': Icons.emoji_events},
//     {'name': 'La Liga', 'icon': Icons.emoji_events},
//     {'name': 'Serie A', 'icon': Icons.emoji_events},
//     {'name': 'Bundesliga', 'icon': Icons.emoji_events},
//     {'name': 'Ligue 1', 'icon': Icons.emoji_events},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 90,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _leagues.length,
//         itemBuilder: (context, index) {
//           final isSelected = _selectedIndex == index;
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             child: Container(
//               width: 70,
//               margin: EdgeInsets.only(right: 12),
//               decoration: BoxDecoration(
//                 color:
//                     isSelected
//                         ? Theme.of(context).primaryColor.withOpacity(0.1)
//                         : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color:
//                       isSelected
//                           ? Theme.of(context).primaryColor
//                           : Colors.grey.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     _leagues[index]['icon'],
//                     color:
//                         isSelected
//                             ? Theme.of(context).primaryColor
//                             : Colors.grey,
//                     size: 28,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     _leagues[index]['name'],
//                     style: TextStyle(
//                       color:
//                           isSelected
//                               ? Theme.of(context).primaryColor
//                               : Colors.grey[700],
//                       fontSize: 12,
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                     ),
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // lib/widgets/league_selector.dart
// import 'package:flutter/material.dart';
// import 'package:livekick/models/odds.dart';

// class LeagueSelector extends StatelessWidget {
//   final List<LeagueInfo> leagues;
//   final int selectedLeagueId;
//   final Function(int) onLeagueSelected;

//   const LeagueSelector({
//     required this.leagues,
//     required this.selectedLeagueId,
//     required this.onLeagueSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<int>(
//       decoration: InputDecoration(
//         labelText: 'League',
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//       value: selectedLeagueId > 0 ? selectedLeagueId : null,
//       hint: Text('Select League'),
//       onChanged: (value) {
//         if (value != null) {
//           onLeagueSelected(value);
//         }
//       },
//       items:
//           leagues.map((league) {
//             return DropdownMenuItem<int>(
//               value: league.id,
//               child: Text('${league.name} (${league.country})'),
//             );
//           }).toList(),
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
    Key? key,
    required this.leagues,
    required this.selectedLeagueId,
    required this.onLeagueSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: leagues.isNotEmpty ? selectedLeagueId : null,
          hint: Text('Select League'),
          items: [
            // Add an "All Leagues" option
            DropdownMenuItem<int>(value: 0, child: Text('All Leagues')),
            // Add all available leagues
            ...leagues.map(
              (league) => DropdownMenuItem<int>(
                value: league.id,
                child: Text('${league.name} (${league.country})'),
              ),
            ),
          ],
          onChanged: (int? value) {
            if (value != null) {
              onLeagueSelected(value);
            }
          },
        ),
      ),
    );
  }
}
