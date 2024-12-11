import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carimakanu_app/pages/welcome.pages.dart';


class searchPage extends StatefulWidget {
  searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWelcomePage(),
        body: Column(
          children: [
            _searchField(),  // This will remain fixed and won't scroll
            Expanded(  // This will make the ListView take the remaining space
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  SizedBox(height: 5),
                  textFieldRFY(),
                  SizedBox(height: 20),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Text textFieldRFY() {
    return Text(
              'Recommended for you',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Lexend',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            );
  }





  Container _searchField() {
    return Container(
      width: 400,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0
          )
          ]
      ),
      child: TextField(
        decoration: InputDecoration(

            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset('assets/icons/Search 02.svg'),
            ),

            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none
            )
        ),
      ),
    );
  }

  AppBar appBarWelcomePage() {
    return AppBar(

      backgroundColor: Colors.white, // Background color of the AppBar
      elevation: 0, // Remove shadow
      toolbarHeight: 100.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
        children: [
          // Back Button Icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomePage(email: FirebaseAuth.instance.currentUser?.email ?? ''),
                ),              ); // Navigate back to the previous screen
            },

            child: Container(
              margin: EdgeInsets.only(right: 10), // Add some margin to separate it from the text
              child: SvgPicture.asset(
                'assets/icons/tombol back.svg',
                width: 55, // Adjust size as needed
                height: 54,
              ),
            ),
          ),
          // Text beside the icon
          Text(
            'Nikmati Rasa, \nTemukan Bahagia',
            style: TextStyle(
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

}
