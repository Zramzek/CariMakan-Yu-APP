import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if the email is registered
  Future<String> checkEmailRegistration(String email) async {
    var userDoc = await _firestore.collection('users').doc(email).get();
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

  // Update username
  Future<void> updateUsername(String email, String username) async {
    await _firestore
        .collection('users')
        .doc(email)
        .update({'username': username});
  }

  // Simulate sending OTP
  Future<void> sendOtp(String email) async {
    // Use your preferred OTP service here (Firebase Auth, SendGrid, etc.)
    print('Sending OTP to $email');
  }
}
