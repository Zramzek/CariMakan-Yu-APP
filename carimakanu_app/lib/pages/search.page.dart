import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carimakanu_app/pages/informasikedai.pages.dart';
import 'package:flutter_svg/svg.dart';

import '../models/kedai.models.dart';

class searchPage extends StatefulWidget {
  final String username;
  final String idUser;
  const searchPage({Key? key, required this.username, required this.idUser});

  @override
  State<searchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<searchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWelcomePage(),
        body: Column(
          children: [
            _searchField(),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Kedai')
                    .where('namaKedai', isGreaterThanOrEqualTo: searchQuery)
                    .where('namaKedai', isLessThanOrEqualTo: searchQuery + '\uf8ff')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Tidak ada kedai ditemukan'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // Konversi snapshot menjadi objek Kedai
                        var kedai = Kedai.fromFirestore(snapshot.data!.docs[index]);
                        return ListTile(
                          title: Text(kedai.name), // Menggunakan kedai.name dari model Kedai
                          subtitle: Text(kedai.alamat), // Menggunakan kedai.alamat dari model Kedai
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => informasiKedai(
                                  kedai: kedai, // Mengirim objek Kedai
                                  username: widget.username,
                                  idUser: widget.idUser,
                                ),
                              ),
                            );
                          },
                        );
                      }
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari kedai...',
          border: InputBorder.none,
          icon: SvgPicture.asset('assets/icons/Search 02.svg'),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  AppBar appBarWelcomePage() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 100.0,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              'assets/icons/tombol back.svg',
              height: 54,
            ),
          ),
          const SizedBox(width: 10),
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
