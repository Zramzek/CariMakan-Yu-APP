import 'package:cloud_firestore/cloud_firestore.dart';

class Kategori {
  final String nameKategori;

  Kategori({
    required this.nameKategori,
  });

  factory Kategori.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Kategori(
      nameKategori: data['nameKategori'] ?? '',
    );
  }
}
