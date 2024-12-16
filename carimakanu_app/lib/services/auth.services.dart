import 'dart:convert';
import 'package:carimakanu_app/config/mailer.config.dart';
import 'package:carimakanu_app/config/otp.config.dart';
// import 'package:carimakanu_app/models/person.models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MailerConfig mailerConfig = MailerConfig();

  // Future<Person?> getPersonByEmail(String email) async {
  //   try {
  //     DocumentSnapshot doc =
  //         await _firestore.collection('Person').doc(email).get();
  //     if (doc.exists) {
  //       return Person.fromFirestore(doc);
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error fetching person: $e');
  //     return null;
  //   }
  // }

  Future<String> checkEmailRegistration(String email) async {
    try {
      var userDoc = await _firestore.collection('Person').doc(email).get();
      return userDoc.exists ? 'registered' : 'unregistered';
    } catch (e) {
      print('Error checking email registration: $e');
      return 'error';
    }
  }

  Future<String> generateidUser(String email) async {
    String idUser;
    try {
      final bytes = utf8.encode(email);
      idUser = sha256.convert(bytes).toString();
    } catch (e) {
      idUser = 'error';
      print('Error generating userId: $e');
    }
    return idUser;
  }

  // Future<void> createPerson(Person person) async {
  //   Future<void> createPerson(Person person) async {
  //     try {
  //       await _firestore
  //           .collection('Person')
  //           .doc(person.email)
  //           .set(person.toFirestore());
  //     } catch (e) {
  //       print('Error creating person: $e');
  //     }
  //   }

  Future<void> insertEmail(String email) async {
    try {
      final idUser = await generateidUser(email);
      await _firestore.collection('Person').doc(email).set({
        'idUser': idUser,
        'email': email,
        'username': null,
        'hasKedai': false,
        'otp': null,
        'otpExpiry': null,
        'created_at': FieldValue.serverTimestamp(),
      });
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
}
