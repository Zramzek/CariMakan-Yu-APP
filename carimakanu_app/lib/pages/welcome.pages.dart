import 'package:carimakanu_app/pages/kedai.pages.dart';
import 'package:carimakanu_app/pages/search.page.dart';
import 'package:carimakanu_app/services/auth.services.dart';
import 'package:carimakanu_app/services/person.services.dart';
import 'package:carimakanu_app/widgets/kedaiListView.widgets.dart';
import 'package:carimakanu_app/widgets/logout.widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthServices _authServices = AuthServices();
  final PersonServices _personServices = PersonServices();

  String? username = '';
  String email = '';
  bool isLoading = true;

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
      String? emailFromJWT = await _personServices.getEmailFromJWT();
      email = emailFromJWT ?? '';
      print('Email from JWT: $email');
      await fetchUsername(email);
    }
  }

  Future<void> fetchUsername(String email) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Person')
          .doc(email)
          .get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'];
          isLoading = false;
        });
      } else {
        throw Exception('User document does not exist');
      }
    } catch (e) {
      print('Error fetching username: $e');
      setState(() {
        username = 'Guest'; // Fallback in case of errors
        isLoading = false;
      });
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
        floatingActionButton: buildKedaiButton(context),
      ),
    );
  }

  FloatingActionButton buildKedaiButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KedaiPage()),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SvgPicture.asset('assets/icons/Group 5.svg'),
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
          fit: BoxFit.cover,
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
        color: const Color(0xffD32B28),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Recommended for you',
        style: TextStyle(
          fontFamily: 'Lexend',
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
              const Text('Search...'), // Placeholder text
            ],
          ),
        ),
      ),
    );
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
          LogoutButton(),
        ],
      ),
    );
  }
}
