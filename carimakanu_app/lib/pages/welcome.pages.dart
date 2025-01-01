import 'package:carimakanu_app/pages/search.page.dart';
import 'package:carimakanu_app/pages/informasikedai.pages.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWelcomePage(context),
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
              height: 600,
              child: buildKedaiListView(context),
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
        Navigator.pushNamed(context, '/welcome/kedai');
      },
      backgroundColor: Colors.red,
      elevation: 0,
      shape: const CircleBorder(),
      child: const Image(image: AssetImage('assets/images/House.png')),
    );
  }

  KedaiListView buildKedaiListView(BuildContext context) {
    return KedaiListView(
      onItemTap: (kedai) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => informasiKedai(
              kedai: kedai,
              username: '$username',
            ),
          ),
        );
      },
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
            MaterialPageRoute(
                builder: (context) => searchPage(
                      username: '$username',
                    )),
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

  void showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 10),
                Text(
                  '$username',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const LogoutButton(),
              ],
            ),
          ),
        );
      },
    );
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

  AppBar appBarWelcomePage(BuildContext context) {
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
          ElevatedButton(
            onPressed: () {
              showProfileDialog(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
