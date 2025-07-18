import 'package:carimakanu_app/pages/kedai.pages.dart';
import 'package:carimakanu_app/pages/search.page.dart';
import 'package:carimakanu_app/services/auth.services.dart';
import 'package:carimakanu_app/services/person.services.dart';
import 'package:carimakanu_app/widgets/kedaiListView.widgets.dart';
import 'package:carimakanu_app/widgets/logout.widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<WelcomePage> {
  final AuthServices _authServices = AuthServices();
  final PersonServices _personServices = PersonServices();
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    isSessionValid();
  }

  void isSessionValid() async {
    if (await _authServices.validateSession() == false) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/auth',
            (Route<dynamic> route) => false,
      );
    } else {
      String? emailFromJWT = await _personServices.getEmailFromJWT();  // Await the future
      email = emailFromJWT ?? '';  // If null, assign an empty string
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWelcomePage(),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 20),
            imageCMU(),
            const SizedBox(height: 0),
            _searchField(context),
            const SizedBox(height: 20),
            AllProducts(),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: KedaiListView(
                onItemTap: (kedai) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomePage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: ListKedai(context),
      ),
    );
  }

  FloatingActionButton ListKedai(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to KedaiPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KedaiPage()),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      child:
          SvgPicture.asset('assets/icons/Group 5.svg'), // Use the desired icon
    );
  }

  Container imageCMU() {
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          image: const AssetImage('assets/images/makanan.png'),
          fit: BoxFit
              .cover, // Scale the image to cover the containershape: BoxShape.circle
        ),
      ),
      child: const Center(
        child: Text(
          'CariMakan U',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lexend',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container AllProducts() {
    return Container(
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xffD32B28), // Warna latar belakang tombol
          borderRadius: BorderRadius.circular(8), // Membuat sudut melengku
        ),
        child: const Text(
          'Recommended for you',
          style: TextStyle(
            fontFamily: 'Lexend',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decorationColor: Colors.blue,
            decorationThickness: 2,
          ),
        ));
  }

  Container _searchField(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => searchPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset('assets/icons/Search 02.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUsername(String userId) async {
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Person')
          .doc(userId)
          .get();

      // Extract the username and update the state
      setState(() {
        username = userDoc['username'] ?? 'Guest';
      });
    } catch (e) {
      print('Error fetching username: $e');
      setState(() {
        username = 'Guest'; // Fallback in case of error
      });
    }
  }

  AppBar appBarWelcomePage() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 100.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang,\n$username',
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomePage(),
                ),
              );
            },
            child: SvgPicture.asset('assets/icons/User Profile Circle.svg'),
          ),
          LogoutButton(
            onLogout: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.remove('email');
              Get.toNamed('/auth');
            },
          ),
        ],
      ),
    );
  }
}
