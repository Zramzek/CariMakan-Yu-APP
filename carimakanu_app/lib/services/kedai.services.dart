import 'dart:convert';
import 'package:carimakanu_app/services/auth.services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class KedaiServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServices _authServices = AuthServices();

  Future<String> generateidKedai(String namaKedai) async {
    String idKedai;
    try {
      final bytes = utf8.encode(namaKedai);
      idKedai = sha256.convert(bytes).toString();
    } catch (e) {
      idKedai = 'error';
      print('Error generating idKedai: $e');
    }
    return idKedai;
  }

  Future<void> addKedaitoFirestore(
    String idUser,
    String namaKedai,
    String informasi,
    String kategori,
    String subKategori,
    String iconPath,
    String alamat,
  ) async {
    try {
      final idKedai = await generateidKedai(namaKedai);
      await _firestore.collection('Kedai').doc(idKedai).set({
        'idKedai': idKedai,
        'idUser': idUser,
        'namaKedai': namaKedai,
        'informasi': informasi,
        'kategori': kategori,
        'subkategori': subKategori,
        'iconPath': iconPath,
        'alamat': alamat,
        'rating': 0,
        'jumlahRating': 0,
        'created_at': FieldValue.serverTimestamp(),
      });
      print('Success adding kedai to Firestore');
      await _authServices.updateRole(idUser);
    } catch (e) {
      print('Error adding kedai to Firestore: $e');
    }
  }

  Future<double> getJumlahRating(String idKedai) async {
    double rating = 0;
    try {
      await _firestore
          .collection('Review')
          .where('idKedai', isEqualTo: idKedai)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          rating += doc['rating'];
        }
      });
      print('success getting rating');
    } catch (e) {
      print('Error getting rating: $e');
    }
    return rating;
  }

  Future<int> getCountRating(String idKedai) async {
    int jumlahRating = 0;
    try {
      await _firestore
          .collection('Review')
          .where('idKedai', isEqualTo: idKedai)
          .get()
          .then((QuerySnapshot querySnapshot) {
        jumlahRating = querySnapshot.docs.length;
      });
      print('success getting jumlahRating');
    } catch (e) {
      print('Error getting jumlahRating: $e');
    }
    return jumlahRating;
  }

  Future<void> updateJumlahRating(String idKedai) async {
    int countRating = await getCountRating(idKedai);
    try {
      await _firestore.collection('Kedai').doc(idKedai).update({
        'jumlahRating': countRating,
      });
      print('Success updating jumlahRating');
    } catch (e) {
      print('Error updating jumlahRating: $e');
    }
  }

  Future<void> updateRating(String idKedai) async {
    double jumlahRating = await getJumlahRating(idKedai);
    int countRating = await getCountRating(idKedai);
    try {
      await _firestore.collection('Kedai').doc(idKedai).update({
        'rating': jumlahRating / countRating,
      });
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  Future<void> deleteKedai(String idKedai) async {
    try {
      await _firestore.collection('Kedai').doc(idKedai).delete();
    } catch (e) {
      print('Error deleting kedai: $e');
    }
  }
}
