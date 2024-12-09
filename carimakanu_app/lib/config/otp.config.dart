import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:email_otp/email_otp.dart';

class OTPConfig {
  static EmailPort mapPortToEmailPort(int port) {
    switch (port) {
      case 25:
        return EmailPort.port25;
      case 465:
        return EmailPort.port465;
      case 587:
        return EmailPort.port587;
      default:
        throw Exception('Unsupported SMTP port: $port');
    }
  }

  static void initialize() {
    EmailOTP.config(
      appName: 'Your App Name',
      otpType: OTPType.numeric,
      expiry: 30000,
      emailTheme: EmailTheme.v6,
      appEmail: dotenv.env['SMTP_USER']!,
      otpLength: 6,
    );

    EmailOTP.setSMTP(
      host: dotenv.env['SMTP_HOST']!,
      emailPort: mapPortToEmailPort(int.parse(dotenv.env['SMTP_PORT']!)),
      secureType: SecureType.tls,
      username: dotenv.env['SMTP_USER']!,
      password: dotenv.env['SMTP_PASS']!,
    );
  }
}
