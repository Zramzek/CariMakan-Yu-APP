import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Kedai {
  final String name;
  final String kategori;
  final String iconPath;
  final String alamat;
  final double rating;
  final int jumlahRating;

  Kedai({
    required this.name,
    required this.kategori,
    required this.iconPath,
    required this.alamat,
    required this.rating,
    required this.jumlahRating,
  });

  factory Kedai.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Kedai(
      name: data['name'] ?? '',
      kategori: data['kategori'] ?? '',
      iconPath: data['iconPath'] ?? '',
      alamat: data['alamat'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      jumlahRating: data['jumlahRating'] ?? 0,
    );
  }
}

class KedaiScreen extends StatelessWidget {
  const KedaiScreen({super.key});

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
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            final KedaiList = snapshot.data!.docs
                .map((doc) => Kedai.fromFirestore(doc))
                .toList();

            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: KedaiList.length,
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 40,
              ),
              separatorBuilder: (context, index) => const SizedBox(
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Image.asset(
                            Kedai.iconPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Kedai.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lexend',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Kedai.kategori,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lexend',
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    'abc' ' |',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.star,
                                      size: 12, color: Colors.orange),
                                  Text(
                                    Kedai.rating.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'Lexend'),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '| ${Kedai.jumlahRating} rating',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Address
                              Text(
                                Kedai.alamat,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: 'Lexend'),
                              ),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.topRight,
                          child:
                              Icon(Icons.bookmark_border, color: Colors.grey),
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
  final Kedai kedai;

  const InformasiKedai({super.key, required this.kedai});

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
