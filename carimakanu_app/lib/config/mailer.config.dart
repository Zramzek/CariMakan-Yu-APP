import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailerConfig {
  final SmtpServer smtpServer;

  MailerConfig()
      : smtpServer = SmtpServer(
          dotenv.env['SMTP_HOST']!,
          port: int.parse(dotenv.env['SMTP_PORT']!),
          username: dotenv.env['SMTP_USER']!,
          password: dotenv.env['SMTP_PASS']!,
          ssl: true, // Use SSL (Gmail requires this for secure connections)
          ignoreBadCertificate: true, // Ignore invalid certificates (optional)
        );

  Future<bool> sendMail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final message = Message()
      ..from = Address(dotenv.env['SMTP_USER']!, 'Your App Name')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      if (kDebugMode) {
        print('Message sent: ${sendReport.toString()}');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Message not sent. Error: $e');
      }
      // You can add more specific error handling here based on the error
      return false;
    }
  }
}
