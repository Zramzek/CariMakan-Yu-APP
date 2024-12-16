import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    try {
      await Future.delayed(const Duration(milliseconds: 3000), () {});
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(100),
          Image.asset(
            'assets/images/logo.png',
            width: 200,
          ),
          const Text(
            'CariMakan-U',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.grey,
            size: 200,
          ),
        ],
      ),
    ));
  }
}

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}
