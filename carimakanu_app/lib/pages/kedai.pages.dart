import 'package:carimakanu_app/models/kedai.models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KedaiPage extends StatefulWidget {
  const KedaiPage({super.key});

  @override
  State<KedaiPage> createState() => _KedaiPageState();
}

class _KedaiPageState extends State<KedaiPage> {
  Stream<List<Kedai>> fetchKedaiList() {
    return FirebaseFirestore.instance
        .collection('Kedai')
        .limit(7)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Kedai.fromFirestore(doc)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/icons/tombol back.svg',
                    width: 55,
                    height: 54,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Tambah Informasi',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                // Add Kedai action
              },
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/welcome/kedai/kedaiForm');
                        },
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: Icon(Icons.add_circle_outline,
                            size: 40, color: Colors.red),
                      ),
                      SizedBox(height: 4),
                      Text("Add Kedai",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lexend',
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Kedai>>(
              stream: fetchKedaiList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Kedai data available.'));
                }

                final kedaiList = snapshot.data!;

                return ListView.builder(
                  itemCount: kedaiList.length,
                  itemBuilder: (context, index) {
                    final kedai = kedaiList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          kedai.iconPath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 80),
                        ),
                        title: Text(
                          kedai.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(kedai.kategori),
                            const SizedBox(height: 4),
                            Text(
                              kedai.alamat,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.orange, size: 16),
                                Text(
                                    "${kedai.rating.toStringAsFixed(1)} | ${kedai.jumlahRating} ratings"),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
