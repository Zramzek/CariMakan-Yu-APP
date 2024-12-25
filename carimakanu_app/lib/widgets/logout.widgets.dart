import 'package:carimakanu_app/services/auth.services.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  iconColor: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final AuthServices authServices = AuthServices();
                  authServices.deleteSession();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth',
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Keluar'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  iconColor: Colors.white,
                  textStyle: const TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
            ],
            title: const Text('Konfirmasi Logout'),
            contentPadding: const EdgeInsets.all(20),
            content: const Text('Apakah Anda yakin ingin keluar?'),
          ),
        );
      },
      child: Text('Logout'),
    );
  }
}
