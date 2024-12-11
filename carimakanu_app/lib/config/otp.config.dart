import 'dart:math';

class OTPManager {
  String? _otp;
  DateTime? _expiryTime;

  // Generate and store OTP with expiration
  Map<String, String> generateOtp(
      {int length = 6, Duration expiryDuration = const Duration(minutes: 2)}) {
    _otp = List.generate(length, (_) => (0 + (Random().nextInt(9))).toString())
        .join();
    _expiryTime = DateTime.now().add(expiryDuration);
    return {
      "otp": _otp!,
      "expiryTime": _expiryTime!.toIso8601String(),
    };
  }
}
