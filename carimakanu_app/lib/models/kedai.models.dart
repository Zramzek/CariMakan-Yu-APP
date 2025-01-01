import 'package:cloud_firestore/cloud_firestore.dart';

class Kedai {
  final String idUser;
  final String idKedai;
  final String namaKedai;
  final String kategori;
  final String subKategori;
  final String informasi;
  final String alamat;
  final double rating;
  final int jumlahRating;
  final String iconPath;
  final String status;
  // final String createdAt;

  Kedai({
    required this.idKedai,
    required this.idUser,
    required this.namaKedai,
    required this.kategori,
    required this.subKategori,
    required this.informasi,
    required this.alamat,
    required this.rating,
    required this.jumlahRating,
    required this.iconPath,
    required this.status,
    // required this.createdAt,
  });

  factory Kedai.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Kedai(
      idKedai: data['idKedai'],
      idUser: data['idUser'],
      namaKedai: data['namaKedai'],
      kategori: data['kategori'],
      subKategori: data['subKategori'],
      informasi: data['informasi'],
      alamat: data['alamat'],
      rating: data['rating'],
      jumlahRating: data['jumlahRating'],
      iconPath: data['iconPath'],
      status: data['status'],
      // createdAt: data['createdAt'],
    );
  }
}
