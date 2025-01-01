import 'package:carimakanu_app/models/kedai.models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KedaiListView extends StatefulWidget {
  final Function(Kedai) onItemTap;

  const KedaiListView({super.key, required this.onItemTap});

  @override
  State<KedaiListView> createState() => _KedaiListViewState();
}

class _KedaiListViewState extends State<KedaiListView> {
  Stream<List<Kedai>> fetchKedaiList() {
    return FirebaseFirestore.instance.collection('Kedai').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Kedai.fromFirestore(doc)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kedai'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/welcome/kedai/kedaiForm');
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
                        child: const Icon(Icons.add_circle_outline,
                            size: 40, color: Colors.red),
                      ),
                      const SizedBox(height: 4),
                      const Text("Add Kedai",
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
                          kedai.namaKedai,
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

class KedaiListViewWidget extends StatelessWidget {
  final Function(Kedai) onItemTap;

  const KedaiListViewWidget({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return KedaiListView(onItemTap: onItemTap);
  }
}
