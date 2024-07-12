import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'HomePageUni.dart';
import 'RegisterPage.dart';
import 'forgotpwPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool obscureText = true;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Welcome',
      'Welcome to UniStudy',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
  void _showErrorDialog(String message) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void validateCredentials() async {
    if (emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email');
      return;
    }

    if (passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String url =
        "https://syfer001testing.000webhostapp.com/cloneapi/loginflutterreturnid.php";

    final Map<String, dynamic> queryParams = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      final response = await http
          .get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body);
        if (user['success']) {
          final userIdProfile = user['userId'];
          emailController.clear();
          passwordController.clear();
          // Show notification
          await _showNotification();
          // Navigate to the Homepage if login is successful
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageUni(userId: userIdProfile)),
          );
          _clearFormFields();
        } else {
          setState(() {
            _showErrorDialog('Invalid email or password');
          });
        }
      } else {
        setState(() {
          _showErrorDialog('Error: ${response.reasonPhrase}');
        });
      }
    } catch (error) {
      setState(() {
        _showErrorDialog('Error occurred: $error');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearFormFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? screenWidth * 0.2 : 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login_pgimg.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Login",
                style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold,color: Colors.black),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.0),
              Text(
                "Login to your account",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 30.0),
              TextField(

                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // Handle forgot password action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.grey[800],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ))

                  : MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: validateCredentials,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      height: 50,
                      onPressed: () {
                        // Handle Google login
                      },
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: MaterialButton(
                      height: 50,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                        // Handle Facebook login
                      },
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "Facebook",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "Create a new account",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
