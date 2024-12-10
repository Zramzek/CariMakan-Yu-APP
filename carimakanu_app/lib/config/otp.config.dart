import 'dart:math';

class OTPManager {
  String? _otp;
  DateTime? _expiryTime;

  // Generate and store OTP with expiration
  String generateOtp(
      {int length = 6, Duration expiryDuration = const Duration(minutes: 2)}) {
    _otp = List.generate(length, (_) => (0 + (Random().nextInt(9))).toString())
        .join();
    _expiryTime = DateTime.now().add(expiryDuration);
    return _otp!;
  }

  // Verify OTP and check expiration
  bool verifyOtp(String enteredOtp) {
    if (_otp == null || _expiryTime == null) {
      return false; // OTP not set
    }
    if (DateTime.now().isAfter(_expiryTime!)) {
      return false; // OTP expired
    }
    return _otp == enteredOtp; // Check if OTP matches
  }
}
