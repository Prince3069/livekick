
import 'package:flutter/material.dart';
import 'core/firebase_init.dart';
import 'features/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initializeApp();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeKick',
      home: Scaffold(
        appBar: AppBar(title: Text('LifeKick Home')),
        body: Center(child: Text('Welcome to LifeKick')),
      ),
    );
  }
}
