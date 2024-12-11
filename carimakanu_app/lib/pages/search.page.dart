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
        appBar: AppBar(
          title: Text("Welcome Page"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(height: 5),
              textFieldRFY(),
              SizedBox(height: 20),
              // Add more widgets here if needed
              SizedBox(height: 20),
            ],
          ),
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

      toolbarHeight: 100.0,
      title: Row(
        children: [
          GestureDetector(
        onTap: () {
    },

            child: Container(
              child: SvgPicture.asset(
                'assets/icons/tombol back.svg',
                height: 54,
              ),
            ),
          ),
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
