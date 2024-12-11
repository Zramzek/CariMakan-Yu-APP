import 'package:flutter/material.dart';
import 'package:carimakanu_app/helpers/jwt.helpers.dart'; // Import your AuthService or JWTHelpers

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final isValid =
        await JWTHelpers.validateToken(); // Replace with JWTHelpers if needed
    if (isValid) {
      Navigator.pushReplacementNamed(
          context, '/welcome'); // Redirect to Welcome Page
    } else {
      Navigator.pushReplacementNamed(
          context, '/auth'); // Redirect to Login Page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 150.0),
          Image.asset(
            'assets/images/logo.png',
          ),
          const CircularProgressIndicator()
        ],
      )), // Loading indicator
    );
  }
}
