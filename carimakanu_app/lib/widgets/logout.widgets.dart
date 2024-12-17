import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Logout'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      onPressed: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');
        Get.toNamed('/auth');
      },
    );
  }
}
