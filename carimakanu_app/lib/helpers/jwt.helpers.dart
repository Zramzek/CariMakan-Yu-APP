import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JWTHelpers {
  static const _storage = FlutterSecureStorage();
  static final String? _secretKey = dotenv.env['JWT_SECRET'];

  // Generate JWT Token
  static Future<void> generateToken(String email) async {
    final jwt = JWT({
      'email': email,
      'exp':
          DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
              1000
    });
    final token = jwt.sign(SecretKey(_secretKey!));

    // Store token securely
    await _storage.write(key: "token", value: token);
  }

  // Validate JWT Token
  static Future<bool> validateToken() async {
    try {
      final token = await _storage.read(key: "token");
      if (token == null) return false;

      final jwt = JWT.verify(token, SecretKey(_secretKey!));
      if (kDebugMode) {
        print("Token is valid: ${jwt.payload}");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Invalid token: $e");
      }
      return false;
    }
  }
}
