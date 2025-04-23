// lib/screens/profile_screen.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    _currentUser = _auth.currentUser;
    setState(() {
      _isLoggedIn = _currentUser != null;
    });
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _isLoggedIn ? _buildLoggedInView() : _buildLoginView(),
    );
  }

  Widget _buildLoggedInView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    _currentUser?.displayName?.substring(0, 1).toUpperCase() ??
                        _currentUser!.email!.substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _currentUser?.displayName ?? 'Football Fan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  _currentUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          _buildSettingsSection(),
          SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(200, 45),
              ),
              child: Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginView() {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Log in to access all features',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              try {
                await _auth.signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                );
                _checkLoginStatus();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login failed: ${e.toString()}')),
                );
              }
            },
            child: Text('Log In'),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // TODO: Navigate to registration screen
            },
            child: Text('Don\'t have an account? Sign up'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to notifications settings
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorite Teams'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to favorite teams screen
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('App Settings'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to app settings screen
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
