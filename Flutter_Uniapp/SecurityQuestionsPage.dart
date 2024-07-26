import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ThemeNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: SecurityQuestionsPage(),
    ),
  );
}

class SecurityQuestionsPage extends StatefulWidget {
  @override
  _SecurityQuestionsPageState createState() => _SecurityQuestionsPageState();
}

class _SecurityQuestionsPageState extends State<SecurityQuestionsPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  String? _savedQuestion;
  String? _savedAnswer;

  @override
  void initState() {
    super.initState();
    _loadSecurityQuestions();
  }

  Future<void> _loadSecurityQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedQuestion = prefs.getString('security_question');
      _savedAnswer = prefs.getString('security_answer');
    });
  }

  Future<void> _saveSecurityQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('security_question', _questionController.text);
    await prefs.setString('security_answer', _answerController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Security question and answer saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Security Questions', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            centerTitle: true,
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
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set your security question and answer:',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  elevation: 10, // Increased elevation for larger shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,// Black shadow color
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _questionController,
                          decoration: InputDecoration(
                            labelText: 'Enter Security Question',
                            labelStyle: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.question_answer,
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _answerController,
                          decoration: InputDecoration(
                            labelText: 'Enter Answer',
                            labelStyle: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _saveSecurityQuestions,
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: themeNotifier.themeMode == ThemeMode.dark
                                ? Colors.black
                                : Colors.white,
                            backgroundColor: themeNotifier.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if (_savedQuestion != null && _savedAnswer != null) ...[
                  Divider(),
                  Card(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                    elevation: 10, // Increased elevation for larger shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black, // Black shadow color
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Security Question:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _savedQuestion!,
                            style: TextStyle(
                              fontSize: 16,
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Saved Answer:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _savedAnswer!,
                            style: TextStyle(
                              fontSize: 16,
                              color: themeNotifier.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
