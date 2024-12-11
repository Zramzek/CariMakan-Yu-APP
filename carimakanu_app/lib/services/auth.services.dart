import 'dart:convert';

import 'package:carimakanu_app/config/mailer.config.dart';
import 'package:carimakanu_app/config/otp.config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MailerConfig mailerConfig = MailerConfig();

  Future<String> checkEmailRegistration(String email) async {
    var userDoc = await _firestore.collection('Person').doc(email).get();
    return userDoc.exists ? 'registered' : 'unregistered';
  }

  Future<String> generateUserId(String email) async {
    final bytes = utf8.encode(email);
    final userid = sha256.convert(bytes).toString();
    return userid;
  }

  Future<void> insertEmail(String email) async {
    final userId = await generateUserId(email);
    await _firestore.collection('Person').doc(email).set({
      'userId': userId,
      'email': email,
      'username': null,
      'otp': null,
      'otpExpiry': null,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveOtpToFirestore(
      String email, String otp, String expiryTime) async {
    await _firestore.collection('Person').doc(email).update({
      'otp': otp,
      'otpExpiry': expiryTime,
    });
  }

  Future<bool> verifyOtpFromFirestore(String email, String enteredOtp) async {
    var userDoc = await _firestore.collection('Person').doc(email).get();
    if (!userDoc.exists) return false;

    String savedOtp = userDoc.data()?['otp'] ?? '';
    DateTime expiryTime = DateTime.parse(userDoc.data()?['otpExpiry'] ?? '');

    if (DateTime.now().isAfter(expiryTime)) {
      return false;
    }

    return savedOtp == enteredOtp;
  }

  // Update username
  Future<void> updateUsername(String email, String username) async {
    await _firestore
        .collection('Person')
        .doc(email)
        .update({'username': username});
  }

  // Simulate sending OTP
  Future<void> sendOtp(String email) async {
    try {
      // Step 1: Generate the OTP and its expiry details
      OTPManager otpManager = OTPManager();
      Map<String, String> generatedOtp =
          otpManager.generateOtp(expiryDuration: const Duration(minutes: 2));
      String otp = generatedOtp['otp']!;
      String expiryTime = generatedOtp['expiryTime']!;

      // Step 2: Send the OTP email
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

      // Step 3: Handle email success and save the OTP to Firestore
      if (result) {
        if (kDebugMode) {
          print("OTP sent successfully");
        }

        // Pass expiryTime as a string to Firestore
        await saveOtpToFirestore(email, otp, expiryTime);
      } else {
        if (kDebugMode) {
          print("Failed to send OTP");
        }
      }
    } catch (e) {
      // Step 4: Handle errors gracefully
      if (kDebugMode) {
        print("Error sending OTP: $e");
      }
    }
  }
}
