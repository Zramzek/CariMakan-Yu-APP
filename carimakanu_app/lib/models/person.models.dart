import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String email;
  String idUser;
  String? username;
  bool hasKedai;
  String? otp;
  String? otpExpiry;
  DateTime? createdAt;

  Person({
    required this.email,
    required this.idUser,
    this.username,
    this.hasKedai = false,
    this.otp,
    this.otpExpiry,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'idUser ': idUser,
      'email': email,
      'username': username,
      'hasKedai': hasKedai,
      'otp': otp,
      'otpExpiry': otpExpiry,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  static Person fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Person(
      email: data['email'],
      idUser: data['idUser'],
      username: data['username'],
      hasKedai: data['hasKedai'],
      otp: data['otp'],
      otpExpiry: data['otpExpiry'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }
}