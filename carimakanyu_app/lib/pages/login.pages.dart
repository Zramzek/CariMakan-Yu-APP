import 'package:flutter/material.dart';
// import '../services/auth.services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final AuthService _auth = AuthService();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/logo.png', // Replace with your actual asset path
              height: 300,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 50),
            // Email input field
            Form(
              // key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan email Anda',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12.0),
                      errorStyle: TextStyle(
                          color: Colors
                              .red), // Optional: customize error text style
                    ),
                    validator: (value) {
                      // Check if the email is empty
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }

                      // Regular expression for email validation
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      // Check if the email format is valid
                      if (!emailRegex.hasMatch(value)) {
                        return 'Format email tidak valid';
                      }

                      // Return null if validation passes
                      return null;
                    },
                    autovalidateMode: AutovalidateMode
                        .onUserInteraction, // Optional: shows validation in real-time
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Info text
            const SizedBox(height: 24),
            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Trim the email to remove any leading/trailing whitespace
                  final email = emailController.text.trim();

                  // More comprehensive email validation
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Regular expression for email validation
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Format email tidak valid'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Simulate OTP sending process
                    // Replace this with your actual OTP sending logic
                    await Future.delayed(const Duration(seconds: 2));

                    // Close loading indicator
                    Navigator.of(context).pop();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode OTP telah dikirim!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Optionally navigate to OTP verification screen
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) => OtpVerificationScreen(email: email)
                    // ));
                  } catch (e) {
                    // Close loading indicator if an error occurs
                    Navigator.of(context).pop();

                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Gagal mengirim kode OTP: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Register link
            GestureDetector(
              onTap: () {},
              // child: const Text.rich(
              //   TextSpan(
              //     text: "Belum punya akun? ",
              //     style: TextStyle(fontSize: 14, color: Colors.grey),
              //     children: [
              //       TextSpan(
              //         text: "Daftar disini",
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Colors.red,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              // ],
              // ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
