// lib/widgets/chat_section.dart
import 'package:flutter/material.dart';

class ChatSection extends StatefulWidget {
  final String matchId;

  const ChatSection({required this.matchId});

  @override
  _ChatSectionState createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'text': 'What a goal by Arsenal!',
      'username': 'FootballFan1',
      'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
    },
    {
      'id': '2',
      'text': 'Chelsea needs to improve their defense',
      'username': 'BluesFan22',
      'timestamp': DateTime.now().subtract(Duration(minutes: 3)),
    },
    {
      'id': '3',
      'text': 'The referee is making some questionable calls',
      'username': 'SoccerRef',
      'timestamp': DateTime.now().subtract(Duration(minutes: 1)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _messages.length,
            reverse: true,
            itemBuilder: (context, index) {
              final message = _messages[_messages.length - 1 - index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          message['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${_formatTimestamp(message['timestamp'])}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(message['text'], style: TextStyle(fontSize: 15)),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(height: 1),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    // TODO: Send message to backend
                    setState(() {
                      _messages.add({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'text': _messageController.text,
                        'username': 'You',
                        'timestamp': DateTime.now(),
                      });
                      _messageController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
