import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PersonServices {
  final storage = FlutterSecureStorage();

  Future<String?> getEmailFromJWT() async {
    final email = await storage.read(key: 'email');
    if (email == '') {
      return null; // Returning null instead of an empty string to handle the case where email is not found
    } else {
      return email;
    }
  }
}
