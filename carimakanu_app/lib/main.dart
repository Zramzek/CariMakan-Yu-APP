import 'package:carimakanu_app/pages/kedai.pages.dart';
import 'package:carimakanu_app/pages/login.pages.dart';
import 'package:carimakanu_app/pages/otp.pages.dart';
import 'package:carimakanu_app/pages/regis.pages.dart';
import 'package:carimakanu_app/pages/welcome.pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:dcdg/dcdg.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _CariMakanuAPP();
}

class _CariMakanuAPP extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('pausing...');
    await Future.delayed(const Duration(seconds: 3));
    print('unpausing...');
    FlutterNativeSplash.remove();
  }

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
        '/welcome': (context) => WelcomePage(
              email: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/welcome/kedai': (context) => KedaiPage(),
      },
    );
  }
}
