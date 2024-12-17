import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KedaiModel {
  final String name;
  final String kategori;
  final String iconPath;
  final String alamat;
  final double rating;
  final int jumlah;
  final Color boxColor;
  final String informasi;

  KedaiModel({
    required this.name,
    required this.kategori,
    required this.iconPath,
    required this.alamat,
    required this.rating,
    required this.jumlah,
    required this.boxColor,
    required this.informasi,
  });

  factory KedaiModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KedaiModel(
      name: data['name'] ?? '',
      kategori: data['kategori'] ?? '',
      iconPath: data['iconPath'] ?? '',
      alamat: data['alamat'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      jumlah: data['jumlah'] ?? 0,
      informasi: data['informasi'] ?? '',
      boxColor: Color(int.parse(data['boxColor'] ?? '0xFFFFFFFF')),
    );
  }
}

class KedaiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        height: 370,
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Kedai').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }

            final KedaiList = snapshot.data!.docs
                .map((doc) => KedaiModel.fromFirestore(doc))
                .toList();

            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: KedaiList.length,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 40,
              ),
              separatorBuilder: (context, index) => SizedBox(
                width: 25,
                height: 20,
              ),
              itemBuilder: (context, index) {
                final Kedai = KedaiList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InformasiKedai(
                          kedai: Kedai,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Kedai.boxColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          width: 120,
                          height: 120,
                          child: Image.asset(
                            Kedai.iconPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Kedai.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lexend',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                Kedai.kategori,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lexend',
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'abc' + ' |',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.star, size: 12, color: Colors.orange),
                                  Text(
                                    Kedai.rating.toString(),
                                    style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Lexend'),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '| ' + Kedai.jumlah.toString() + ' rating',
                                    style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Address
                              Text(
                                Kedai.alamat,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: 'Lexend'
                                ),
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.bookmark_border, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class InformasiKedai extends StatelessWidget {
  final KedaiModel kedai;

  InformasiKedai({required this.kedai});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kedai.name)),
      body: Center(
        child: Text('Details about ${kedai.name}'),
      ),
    );
  }
}
