import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePageUni.dart';
import 'RegisterPage.dart';
import 'ThemeNotifier.dart';
import 'forgotpwPage.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MainApp(),
    ),
  );
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
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }


  Future<void> _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      // If userId is stored, navigate to HomePageUni
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageUni(userId: userId)),
      );
    }
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black),),
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
    });

    String url =
        "https://syfer001testing.000webhostapp.com/cloneapi/Alphaapi.php";
      //https://syfer001testing.000webhostapp.com/cloneapi/loginflutterreturnid.php

    final Map<String, dynamic> queryParams = {
      "requestby" : "Logindata",
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

          // Save userId to shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userIdProfile);

          emailController.clear();
          passwordController.clear();
          // Show notification
          // Navigate to the Homepage if login is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePageUni(userId: userIdProfile)),
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
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
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
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                ),
                style: TextStyle(color: Colors.black),
              ),

              SizedBox(height: 30.0),
              TextField(
                controller: passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });

                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // Handle forgot password action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
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
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
                  : MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: validateCredentials,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0,),),
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
                      child: Text("Google", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0,)),
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
                    MaterialPageRoute(
                        builder: (context) => RegisterPage()),
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
