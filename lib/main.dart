// ignore_for_file: prefer_const_constructors, duplicate_import, unused_import, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';

import 'screens/home_screen.dart';
import 'screens/password_screen.dart';
import 'screens/lock_screen.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  Future<bool> _hasPassword() async {
    final authService = AuthService();
    final password = await authService.getPassword();
    return password != null && password.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSafe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: _hasPassword(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading state
          } else if (snapshot.data == true) {
            // If password exists, navigate to LockScreen
            return FutureBuilder<String?>(
              future: AuthService().getPassword(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return LockScreen(password: snapshot.data!);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            // If no password, navigate to PasswordScreen to set it up
            return PasswordScreen();
          }
        },
      ),
      routes: {
        '/lock': (context) => FutureBuilder<String?>(
              future: AuthService().getPassword(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return LockScreen(password: snapshot.data!);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
      },
    );
  }
}
