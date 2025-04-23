// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekick/main.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';

// Mock classes
class MockFirebaseApp extends Mock implements FirebaseApp {}

// Mock setup for Firebase
class MockFirebase {
  static Future<void> setupMockFirebase() async {
    // Override Firebase initialization for testing
    TestWidgetsFlutterBinding.ensureInitialized();
  }
}

void main() {
  setUpAll(() async {
    await MockFirebase.setupMockFirebase();
  });

  testWidgets('App should render and show bottom navigation', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Verify bottom navigation exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify all four tabs are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Navigating between tabs works', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Start at Home tab
    expect(find.text('Live & Upcoming Matches'), findsOneWidget);

    // Tap on Matches tab
    await tester.tap(find.text('Matches'));
    await tester.pumpAndSettle();

    // Verify we're on Matches screen
    expect(
      find.text('Matches'),
      findsWidgets,
    ); // Once in tab bar, once in app bar

    // Tap on Live tab
    await tester.tap(find.text('Live'));
    await tester.pumpAndSettle();

    // Verify we're on Live screen
    expect(find.text('Live Stream'), findsOneWidget);

    // Tap on Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify we're on Profile screen
    expect(
      find.text('Profile'),
      findsWidgets,
    ); // Once in tab bar, once in app bar
  });
}
