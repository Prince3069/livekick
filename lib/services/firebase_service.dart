// lib/services/firebase_service.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:livekick/models/match.dart';
import 'package:livekick/models/news.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth methods
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Firestore methods
  Future<List<Match>> getLiveMatches() async {
    try {
      final snapshot =
          await _firestore
              .collection('matches')
              .where('isLive', isEqualTo: true)
              .orderBy('matchDate', descending: false)
              .get();

      return snapshot.docs.map((doc) => Match.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error getting live matches: $e');
      return [];
    }
  }

  Future<List<Match>> getUpcomingMatches() async {
    try {
      final now = DateTime.now();
      final snapshot =
          await _firestore
              .collection('matches')
              .where('isLive', isEqualTo: false)
              .where('matchDate', isGreaterThan: now.toIso8601String())
              .orderBy('matchDate', descending: false)
              .limit(10)
              .get();

      return snapshot.docs.map((doc) => Match.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error getting upcoming matches: $e');
      return [];
    }
  }

  Future<List<News>> getLatestNews() async {
    try {
      final snapshot =
          await _firestore
              .collection('news')
              .orderBy('publishedAt', descending: true)
              .limit(10)
              .get();

      return snapshot.docs.map((doc) => News.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error getting latest news: $e');
      return [];
    }
  }

  // Chat methods
  Stream<QuerySnapshot> getChatMessages(String matchId) {
    return _firestore
        .collection('matches')
        .doc(matchId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<void> sendChatMessage(String matchId, String message) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('matches')
        .doc(matchId)
        .collection('messages')
        .add({
          'text': message,
          'userId': user.uid,
          'username': user.displayName ?? 'Anonymous',
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  // User profile methods
  Future<void> updateUserProfile(String displayName, String? photoUrl) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await user.updateDisplayName(displayName);
    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }

    await _firestore.collection('users').doc(user.uid).set({
      'displayName': displayName,
      'email': user.email,
      'photoUrl': photoUrl,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> uploadProfileImage(String filePath, dynamic _storage) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final ref = _storage.ref().child('profile_images/${user.uid}');
    final uploadTask = await ref.putFile(File(filePath));
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  // Favorite teams methods
  Future<void> saveFavoriteTeam(String teamId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'favoriteTeams': FieldValue.arrayUnion([teamId]),
    });
  }

  Future<void> removeFavoriteTeam(String teamId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'favoriteTeams': FieldValue.arrayRemove([teamId]),
    });
  }

  Future<List<String>> getFavoriteTeams() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()?['favoriteTeams'] != null) {
      return List<String>.from(doc.data()!['favoriteTeams']);
    }
    return [];
  }
}

// Add import for File class
// import 'dart:io';
