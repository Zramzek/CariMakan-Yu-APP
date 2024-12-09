import 'package:flutter/material.dart';
import 'package:carimakanu_app/services/auth.services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthServices authServices = AuthServices();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String result = await authServices.checkEmailRegistration(email);

      if (result == 'registered') {
        await authServices.sendOtp(email);
        Navigator.pushNamed(context, '/auth/otp', arguments: email);
      } else if (result == 'unregistered') {
        await authServices.insertEmail(email);
        Navigator.pushNamed(context, '/auth/register', arguments: email);
      } else {
        _showMessage('An unknown error occurred.');
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Masuk untuk mengakses fitur CariMakan U',
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                  'Kami akan mengirimkan kode OTP untuk memverifikasi email anda',
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
                      : const Text('Login',
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
