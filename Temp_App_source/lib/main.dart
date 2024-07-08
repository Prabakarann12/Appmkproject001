import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';

void main() {
  runApp(const Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<void> sendingmail() async {
    try {
      var userEmail = 'prabakarann1298@gmail.com';
      var password = 'jywrqugbvxyyvgtl';

      final smtpServer = gmail(userEmail, password);
      var rng = Random();
      var code = rng.nextInt(900000) + 100000;

      final message = Message()
        ..from = Address(userEmail, 'Unistudy')
        ..recipients.add('dpappteam@gmail.com')
        ..subject = 'Email Validation'
        ..text = 'Your validation code is: $code';

      await send(message, smtpServer);
      print('Email sent successfully');
    } catch (e) {
      print('Failed to send email: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Send Email'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: sendingmail,
            child: const Text('Send'),
          ),
        ),
      ),
    );
  }
}
