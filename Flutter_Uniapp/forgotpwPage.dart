import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isSending = false;
  String _statusMessage = '';
  int? _verificationCode;
  bool obscureText = true;

  Future<void> sendingMail(String recipientEmail) async {
    try {
      setState(() {
        _isSending = true;
        _statusMessage = '';
      });

      var userEmail = 'prabakarann1298@gmail.com'; // Your email
      var password = 'jywrqugbvxyyvgtl'; // Your email app password

      final smtpServer = gmail(userEmail, password);
      var rng = Random();
      _verificationCode = rng.nextInt(900000) + 100000;

      final message = Message()
        ..from = Address(userEmail, 'Unistudy')
        ..recipients.add(recipientEmail)
        ..subject = 'Email Validation'
        ..text = 'Your validation code is: $_verificationCode';
      await send(message, smtpServer);

      setState(() {
        _statusMessage = 'Email sent successfully';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to send email: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _validateCode() {
    if (_verificationCode == null) {
      setState(() {
        _statusMessage = 'Verification code not sent';
      });
      return;
    }

    final enteredCode = int.tryParse(codeController.text);
    if (enteredCode == _verificationCode) {
      _showResetPasswordDialog();
    } else {
      setState(() {
        _statusMessage = 'Invalid verification code';
      });
    }
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Password', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15.0),
              TextField(
                controller: newPasswordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
              ),
              Text(
                _statusMessage,
                style: TextStyle(color: Colors.red, fontSize: 16.0),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text) {
                  if (newPasswordController.text.isNotEmpty) {
                    _resetPassword(emailController.text, newPasswordController.text);
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _statusMessage = 'Password cannot be empty';
                    });
                  }
                } else {
                  setState(() {
                    _statusMessage = 'Passwords do not match';
                  });
                }
              },
              child: Text('Submit', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword(String email, String newPassword) async {
    final url = Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/forgotpassword.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _statusMessage = responseData['message'];
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to reset password. Please try again later.';
        });
      }
    } catch (e) {
      // Handle request error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Forgot Password', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email to receive a verification code',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _isSending
                ? Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ))
                : MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                sendingMail(emailController.text);
              },
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                "Send Verification Code",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: _validateCode,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                "Validate Code",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              _statusMessage,
              style: TextStyle(color: Colors.red, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
