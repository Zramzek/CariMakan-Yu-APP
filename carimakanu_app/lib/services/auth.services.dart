import 'dart:convert';
import 'package:carimakanu_app/config/mailer.config.dart';
import 'package:carimakanu_app/config/otp.config.dart';
import 'package:carimakanu_app/helpers/jwt.helpers.dart';
import 'package:carimakanu_app/models/person.models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MailerConfig mailerConfig = MailerConfig();
  final storage = FlutterSecureStorage();

  Future<String> checkEmailRegistration(String email) async {
    try {
      var userDoc = await _firestore.collection('Person').doc(email).get();
      return userDoc.exists ? 'registered' : 'unregistered';
    } catch (e) {
      print('Error checking email registration: $e');
      return 'error';
    }
  }

  Future<String> generateIdUser(String email) async {
    try {
      final bytes = utf8.encode(email);
      return sha256.convert(bytes).toString();
    } catch (e) {
      print('Error generating userId: $e');
      return 'error';
    }
  }

  Future<void> insertEmail(String email) async {
    try {
      final idUser = await generateIdUser(email);
      Person person = Person(email: email, idUser: idUser);
      await _firestore
          .collection('Person')
          .doc(email)
          .set(person.toFirestore());
    } catch (e) {
      print('Error inserting email: $e');
    }
  }

  Future<void> saveOtpToFirestore(
      String email, String otp, String expiryTime) async {
    try {
      await _firestore.collection('Person').doc(email).update({
        'otp': otp,
        'otpExpiry': expiryTime,
      });
    } catch (e) {
      print('Error saving OTP to Firestore: $e');
    }
  }

  Future<void> updateOtp(String email) async {
    try {
      await _firestore.collection('Person').doc(email).update({
        'otp': 0,
        'otpExpiry': "Verified",
      });
    } catch (e) {
      print('Error updating OTP: $e');
    }
  }

  Future<void> updateRole(String idUser) async {
    try {
      await _firestore.collection('Person').doc(idUser).update({
        'hasKedai': true,
      });
    } catch (e) {
      print('Error updating role: $e');
    }
  }

  Future<bool> verifyOtpFromFirestore(String email, String enteredOtp) async {
    try {
      var userDoc = await _firestore.collection('Person').doc(email).get();
      if (!userDoc.exists) return false;

      String savedOtp = userDoc.data()?['otp'] ?? '';
      DateTime expiryTime = DateTime.parse(userDoc.data()?['otpExpiry'] ?? '');

      if (DateTime.now().isAfter(expiryTime)) {
        return false;
      }

      await updateOtp(email);
      return savedOtp == enteredOtp;
    } catch (e) {
      print('Error verifying OTP from Firestore: $e');
      return false;
    }
  }

  // Update username
  Future<void> updateUsername(String email, String username) async {
    try {
      await _firestore
          .collection('Person')
          .doc(email)
          .update({'username': username});
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      // Generate OTP
      OTPManager otpManager = OTPManager();
      Map<String, String> generatedOtp =
          otpManager.generateOtp(expiryDuration: const Duration(minutes: 2));
      String otp = generatedOtp['otp']!;
      String expiryTime = generatedOtp['expiryTime']!;

      // Save the OTP to Firestore
      await saveOtpToFirestore(email, otp, expiryTime);

      // Send the OTP
      bool result = await mailerConfig.sendMail(
        recipientEmail: email,
        subject: "[CariMakan-U] Verifikasi Kode OTP",
        body: '''
Halo!, 

Kode OTP Anda adalah $otp. Masukkan kode ini untuk menyelesaikan proses verifikasi akun Anda. 

Kode ini hanya berlaku selama 2 menit. Jangan bagikan kode ini kepada siapa pun, termasuk pihak yang mengaku dari CariMakan-U.

Jika Anda tidak meminta kode ini, abaikan pesan ini. 

Terima kasih telah menggunakan CariMakan-U!
''',
      );

      // Handling success scenario
      if (result) {
        if (kDebugMode) {
          print("OTP sent successfully");
        }
      } else {
        if (kDebugMode) {
          print("Failed to send OTP");
        }
      }
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print("Error sending OTP: $e");
      }
    }
  }

  Future<void> saveSession(String token, String email) async {
    try {
      final currentTime = DateTime.now().toIso8601String();
      await storage.write(key: 'sessionToken', value: token);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'lastAccessTime', value: currentTime);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving session: $e');
      }
    }
  }

  Future<bool> validateSession() async {
    try {
      final lastAccess = await storage.read(key: 'lastAccessTime');

      if (lastAccess == null) {
        return false;
      }

      final lastAccessDate = DateTime.parse(lastAccess);
      final currentTime = DateTime.now();

      if (currentTime.difference(lastAccessDate).inDays > 10) {
        await storage.deleteAll();
        return false;
      }

      if (JWTHelpers.validateToken() == false) {
        await storage.deleteAll();
        return false;
      }

      await storage.write(
          key: 'lastAccessTime', value: currentTime.toIso8601String());
      return true;
    } catch (e) {
      print('Error validating session: $e');
      return false;
    }
  }

  Future<void> deleteSession() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting session: $e');
      }
    }
  }
}
