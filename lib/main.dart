import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lock_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Add const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSafe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EntryPoint(),
    );
  }
}


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool _isPasswordSet = false;

  @override
  void initState() {
    super.initState();
    _checkPassword();
  }

  Future<void> _checkPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString('user_password');
    setState(() {
      _isPasswordSet = password != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isPasswordSet ? LockScreen() : HomeScreen();
  }
}
