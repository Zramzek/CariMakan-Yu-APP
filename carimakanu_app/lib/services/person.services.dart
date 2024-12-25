import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PersonServices {
  final storage = FlutterSecureStorage();

  Future<String?> getEmailFromJWT() async {
    final email = storage.read(key: 'email');
    if (email == '') {
      return '';
    } else {
      return email;
    }
  }
}
