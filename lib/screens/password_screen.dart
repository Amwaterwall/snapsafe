// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:snapsafe/services/auth_service.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  void _setPassword() async {
  final password = _passwordController.text;
  if (password.isNotEmpty) {
    final authService = AuthService();
    await authService.setPassword(password);
    Navigator.pushReplacementNamed(context, '/lock');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a password')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Your Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter your password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setPassword,
              child: const Text('Set Password'),
            ),
          ],
        ),
      ),
    );
  }
}
