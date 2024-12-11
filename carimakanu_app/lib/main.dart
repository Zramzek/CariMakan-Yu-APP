import 'package:carimakanu_app/pages/login.pages.dart';
import 'package:carimakanu_app/pages/otp.pages.dart';
import 'package:carimakanu_app/pages/regis.pages.dart';
import 'package:carimakanu_app/pages/welcome.pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.leagueSpartanTextTheme()),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const LoginScreen(),
        '/auth/otp': (context) => OtpScreen(
              email: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/auth/register': (context) => RegisterScreen(
              email: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/welcome': (context) => WelcomePage(),
      },
    );
  }
}
