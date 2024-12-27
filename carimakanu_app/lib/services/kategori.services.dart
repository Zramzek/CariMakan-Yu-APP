import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getKategori() async {
    try {
      await _firestore
          .collection('Kategori')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          print(doc['namaKategori']);
        }
      });
      print('success getting kategori');
    } catch (e) {
      print('Error getting kategori: $e');
    }
  }
}
