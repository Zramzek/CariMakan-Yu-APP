import 'package:flutter/material.dart';
// import '../services/auth.services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final AuthService _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Home'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Home'),
              obscureText: true,
            ),
            // ElevatedButton(
            // onPressed: () async {
            //   final email = emailController.text.trim();
            //   final password = passwordController.text.trim();
            //   final user = await _auth.signIn(email, password);
            //   if (user != null) {
            //     Navigator.pushReplacementNamed(context, '/home');
            //   } else {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Home!')),
            //     );
            //   }
            // },
            // child: const Text('Home'),
            // ),
          ],
        ),
      ),
    );
  }
}
