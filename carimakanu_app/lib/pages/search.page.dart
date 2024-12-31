import 'package:flutter/material.dart';
import 'package:carimakanu_app/pages/informasikedai.pages.dart';
import 'package:carimakanu_app/widgets/kedaiListView.widgets.dart';
import 'package:carimakanu_app/pages/kedai.pages.dart';

import 'package:flutter_svg/svg.dart';

class searchPage extends StatefulWidget {
  final String username;
  const searchPage({Key? key, required this.username});

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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _searchField(),
                  const SizedBox(height: 5),
                  textFieldRFY(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 600, // Set a height limit for the KedaiListView
                    child: buildKedaiListView(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton ListKedai(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
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

  KedaiListView buildKedaiListView(BuildContext context) {
    return KedaiListView(
      onItemTap: (kedai) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => informasiKedai(
              kedai: kedai,
              username: widget.username,
            ),
          ),
        );
      },
    );
  }

  Text textFieldRFY() {
    return const Text(
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
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset('assets/icons/Search 02.svg'),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
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
              Navigator.pop(context); // Go back to the previous screen
            },
            child: Container(
              child: SvgPicture.asset(
                'assets/icons/tombol back.svg',
                height: 54,
              ),
            ),
          ),
          const Text(
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
