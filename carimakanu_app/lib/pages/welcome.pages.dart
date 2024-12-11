
import 'package:carimakanu_app/pages/search.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:carimakanu_app/pages/kedaiPage.dart';

class WelcomePage extends StatefulWidget {
  final String email;

  const WelcomePage({super.key, required this.email});


  @override
  State<WelcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<WelcomePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    String email = widget.email; // Get the passed email
    if (email.isNotEmpty) {
      fetchUsername(email); // Fetch the username from Firestore
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
          MaterialPageRoute(builder: (context) => const kedaiPage()),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SvgPicture.asset('assets/icons/Group 5.svg'), // Use the desired icon
    );
  }

  Container imageCMU() {
    return Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          image: AssetImage('assets/images/makanan.png'),
          fit: BoxFit.cover, // Scale the image to cover the containershape: BoxShape.circle
        ),

      ),

      child: Center(
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xffD32B28), // Warna latar belakang tombol
          borderRadius: BorderRadius.circular(8), // Membuat sudut melengku
        ),
        child: Text(
          'Recommended for you',
          style: TextStyle(
            fontFamily: 'Lexend',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decorationColor: Colors.blue,
            decorationThickness: 2,
          ),
        )

    );
  }

  Container _searchField(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: 30, bottom: 10),
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
            MaterialPageRoute(builder: (context) =>searchPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(15),
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
                style: TextStyle(
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
                  builder: (context) => WelcomePage(email: FirebaseAuth.instance.currentUser?.email ?? ''),
                ),
              );
            },
            child: SvgPicture.asset('assets/icons/User Profile Circle.svg'),
          ),
        ],
      ),
    );
  }
}
