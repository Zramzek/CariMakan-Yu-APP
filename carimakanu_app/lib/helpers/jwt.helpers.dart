import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JWTHelpers {
  static const _storage = FlutterSecureStorage();
  static final String? _secretKey = dotenv.env['JWT_SECRET'];

  static Future<String> generateToken(String email) async {
    final jwt = JWT({
      'email': email,
    });
    final token = jwt.sign(SecretKey(_secretKey!));
    return token;
  }

  static Future<bool> validateToken() async {
    try {
      final token = await _storage.read(key: "token");
      if (token == null) return false;

      final jwt = JWT.verify(token, SecretKey(_secretKey!));
      if (jwt.payload['email'] == null) return false;

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Invalid token: $e");
      }
      return false;
    }
  }
}
