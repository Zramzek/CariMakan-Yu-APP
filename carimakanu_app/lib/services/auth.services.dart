import 'package:carimakanu_app/config/mailer.config.dart';
import 'package:carimakanu_app/config/otp.config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final EmailOTP emailOTP = EmailOTP();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MailerConfig mailerConfig = MailerConfig(); // Initialize mailerConfig

  // Check if the email is registered
  Future<String> checkEmailRegistration(String email) async {
    var userDoc = await _firestore.collection('Person').doc(email).get();
    return userDoc.exists ? 'registered' : 'unregistered';
  }

  // Insert new user with email
  Future<void> insertEmail(String email) async {
    await _firestore.collection('Person').doc(email).set({
      'email': email,
      'username': null, // Placeholder for username
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveOtpToFirestore(
      String email, String otp, Duration expiryDuration) async {
    await _firestore.collection('Person').doc(email).set({
      'otp': otp,
      'otpExpiry': DateTime.now().add(expiryDuration).toIso8601String(),
    });
  }

  Future<bool> verifyOtpFromFirestore(String email, String enteredOtp) async {
    var userDoc = await _firestore.collection('Person').doc(email).get();
    if (!userDoc.exists) return false;

    String savedOtp = userDoc.data()?['otp'] ?? '';
    DateTime expiryTime = DateTime.parse(userDoc.data()?['otpExpiry'] ?? '');

    if (DateTime.now().isAfter(expiryTime)) {
      return false; // OTP expired
    }

    return savedOtp == enteredOtp;
  }

  // Update username
  Future<void> updateUsername(String email, String username) async {
    await _firestore
        .collection('person')
        .doc(email)
        .update({'username': username});
  }

  // Simulate sending OTP
  Future<void> sendOtp(String email) async {
    try {
      OTPManager otpManager = OTPManager();
      String otp = otpManager.generateOtp();
      bool result = await mailerConfig.sendMail(
        recipientEmail: email,
        subject: "Your OTP for Login",
        body: "Your OTP is $otp. It will expire in 2 minutes.",
      );

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
      if (kDebugMode) {
        print("Error sending OTP: $e");
      }
    }
  }
}
