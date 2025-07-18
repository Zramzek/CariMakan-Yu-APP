import 'package:carimakanu_app/helpers/jwt.helpers.dart';
import 'package:carimakanu_app/services/auth.services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _remainingTime = 60; // Timer starts at 60 seconds
  bool _isButtonDisabled = true;

  // To store OTP input
  final _authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isButtonDisabled = false;
          _timer.cancel();
        }
      });
    });
  }

  void _resendOtp() async {
    setState(() {
      _remainingTime = 60;
      _isButtonDisabled = true;
      _startTimer();
    });

    try {
      await _authServices.sendOtp(
        widget.email,
      );
      _showMessage("OTP has been resent to your email.");
    } catch (e) {
      _showMessage("Failed to resend OTP: $e");
    }
  }

  void verifyOtp(String email, String enteredOtp) async {
    bool isValid =
        await _authServices.verifyOtpFromFirestore(email, enteredOtp);

    if (isValid) {
      final token = await JWTHelpers.generateToken(email);
      await _authServices.saveSession(token, email);
      if (kDebugMode) {
        print('OTP verified successfully');
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/welcome',
        (route) => false,
        arguments: email,
      );
    } else {
      if (kDebugMode) {
        print('Invalid or expired OTP');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or expired OTP')),
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Verifikasi Emailmu',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Masukkan kode OTP yang dikirimkan ke:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 6; i++)
                      SizedBox(
                        height: 70,
                        width: 60,
                        child: TextFormField(
                          controller: _otpControllers[i],
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    String enteredOtp = '';
                    for (var i = 0; i < 6; i++) {
                      enteredOtp += _otpControllers[i].text;
                    }
                    verifyOtp(widget.email, enteredOtp);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 24.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Verifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: _isButtonDisabled ? null : _resendOtp,
                  style: TextButton.styleFrom(
                    foregroundColor:
                        _isButtonDisabled ? Colors.grey : Colors.red,
                  ),
                  child: Text(
                    _isButtonDisabled
                        ? 'Kirim ulang kode OTP ($_remainingTime)'
                        : 'Kirim ulang kode OTP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Email tidak bisa diakses?',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle contact us logic
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
