import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'ThemeNotifier.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: HelpSupportPage(),
    ),
  );
}

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;
  String _statusMessage = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitting your query...')),
      );

      _sendEmail(
        _nameController.text,
        _emailController.text,
        _subjectController.text,
        _messageController.text,
      );

      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  Future<void> _sendEmail(String name, String email, String subject, String message) async {
    final smtpServer = gmail('devanathanmurali2001@gmail.com', 'jlclpidtcferqqjr');
    final mailMessage = Message()
    ..from = Address('prabakarann1298@gmail.com', name)
    ..recipients.add('dpappteam@gmail.com')
    ..subject = subject
    ..text = 'Name: $name\nEmail: $email\n\n$message';

    try {
    setState(() {
    _isSending = true;
    _statusMessage = '';
    });

    final sendReport = await send(mailMessage, smtpServer);
    setState(() {
    _isSending = false;
    _statusMessage = 'Email sent: ${sendReport.toString()}';
    });
    } on MailerException catch (e) {
    setState(() {
    _isSending = false;
    _statusMessage = 'Email not sent. \n${e.toString()}';
    });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          themeMode: themeNotifier.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Scaffold(
            backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            appBar: AppBar(
              title: Text(
                'Help & Support',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            body: Stack(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/h&s.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _subjectController,
                          label: 'Subject',
                          icon: Icons.subject,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the subject';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _messageController,
                          label: 'Message',
                          icon: Icons.message,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 200),
                        if (_isSending)
                          Center(child: CircularProgressIndicator())
                        else if (_statusMessage.isNotEmpty)
                          Center(child: Text(_statusMessage)),
                        SizedBox(height: 20),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              shadowColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
              prefixIcon: Icon(
                icon,
                color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
            ),
            validator: validator,
          ),
        );
      },
    );
  }
}
