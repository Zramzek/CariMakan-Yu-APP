import 'package:carimakanu_app/models/kedai.models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KedaiListView extends StatelessWidget {
  final Function(KedaiItem) onItemTap;

  const KedaiListView({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        final kedaiList = snapshot.data!.docs
            .map((doc) => KedaiItem.fromFirestore(doc))
            .toList();

        return ListView.separated(
          itemCount: kedaiList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final kedai = kedaiList[index];
            return GestureDetector(
              onTap: () => onItemTap(kedai),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Image
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(kedai.iconPath, fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 8),
                    // Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kedai.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(kedai.kategori),
                          Text(
                              '${kedai.rating} ★ | ${kedai.jumlahRating} ratings'),
                          Text(kedai.alamat),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
