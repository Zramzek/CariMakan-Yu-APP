import 'package:carimakanu_app/services/auth.services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RegisterScreen extends StatefulWidget {
  final String email;
  const RegisterScreen({super.key, required this.email});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final AuthServices authServices = AuthServices();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      _showMessage('Please enter your username.');
      return;
    }

    await authServices.updateUsername(widget.email, username);
    await authServices.sendOtp(widget.email);

    setState(() {
      _isLoading = true;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Verifikasi'),
          // centerTitle: true, // Centers the AppBar title
          ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 150.0),
              Image.asset(
                'assets/images/logo.png',
              ),
              const SizedBox(height: 8.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'Email anda belum terdaftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Text(
                  'Silahkan masukkan username untuk membuat akun',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.red,
                    // color: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
