        import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String idUser;
  final String username;
  final String email;
  final bool hasKedai;

  Person({
    required this.idUser,
    required this.username,
    required this.email,
    required this.hasKedai,
  });

  factory Person.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Person(
      idUser: data['idUser'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      hasKedai: data['hasKedai'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'username': username,
      'email': email,
      'hasKedai': hasKedai,
    };
  }

  @override
  String toString() {
    return 'Person{idUser: $idUser, username: $username, email: $email, hasKedai: $hasKedai}';
  }
}
