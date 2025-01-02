import 'package:carimakanu_app/form/daftarkedai.form.dart';
import 'package:carimakanu_app/pages/kedai.pages.dart';
import 'package:carimakanu_app/pages/login.pages.dart';
import 'package:carimakanu_app/pages/otp.pages.dart';
import 'package:carimakanu_app/pages/regis.pages.dart';
import 'package:carimakanu_app/pages/welcome.pages.dart';
import 'package:carimakanu_app/services/auth.services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  final AuthServices _authServices = AuthServices();
  final isValidSession = await _authServices.validateSession();
  FlutterNativeSplash.remove();
  runApp(MyApp(isValidSession: isValidSession));
}

class MyApp extends StatefulWidget {
  final bool isValidSession;
  const MyApp({super.key, required this.isValidSession});

  @override
  State<MyApp> createState() => _CariMakanuAPP();
}

class _CariMakanuAPP extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
          primarySwatch: Colors.yellow,
          textTheme: GoogleFonts.leagueSpartanTextTheme()),
      initialRoute: widget.isValidSession == true ? '/welcome' : '/auth',
      routes: {
        '/auth': (context) => const LoginScreen(),
        '/auth/otp': (context) => OtpScreen(
              email: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/auth/register': (context) => RegisterScreen(
              email: ModalRoute.of(context)?.settings.arguments as String,
            ),
        '/welcome': (context) => WelcomePage(),
        '/welcome/kedai': (context) => const KedaiPage(),
        '/welcome/kedai/kedaiForm': (context) => daftarKedaiForm(),
      },
    );
  }
}
