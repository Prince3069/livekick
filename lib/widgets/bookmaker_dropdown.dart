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
        DropdownMenuItem<String>(value: null, child: Text('All Bookmakers')),
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
