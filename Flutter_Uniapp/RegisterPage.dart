import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'SignInPage.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mailer/mailer.dart';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final  _codeController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  File? _profileImage;
  bool _isSending = false;
  String _statusMessage = '';
  int? _verificationCode;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Send OTP to the provided email
      await _sendOTP();
      // Show the OTP popup card
      _showOTPPopup();
    }
  }

  Future<void> _sendOTP() async {
    final email = _emailController.text;

    try {
      setState(() {
        _isSending = true;
        _statusMessage = '';
      });

      var userEmail = 'prabakarann1298@gmail.com'; // Your email
      var password = ''; // Your email app password

      final smtpServer = gmail(userEmail, password);
      var rng = Random();
      _verificationCode = rng.nextInt(900000) + 100000;

      final message = Message()
        ..from = Address(userEmail, 'Unistudy')
        ..recipients.add(email)
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

  void _showOTPPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double increasedWidth = MediaQuery.of(context).size.width * 1.1;
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Enter your OTP', style: TextStyle(color: Colors.black,fontSize: 23.0)),
          content: Padding(
            padding: EdgeInsets.all(8.5), // Add padding around the content
            child: Container(
              width: increasedWidth,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _codeController,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  activeColor: Colors.black,
                  selectedColor: Colors.black,
                  selectedFillColor: Colors.white,
                  inactiveColor: Colors.black,
                  inactiveFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                textStyle: TextStyle(color: Colors.black),
                onChanged: (value) {
                  // Handle changes if needed
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black,fontSize: 16.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Verify', style: TextStyle(color: Colors.black,fontSize: 16.0)),
              onPressed: () {
                _validateCode();
              },
            ),
          ],
        );
      },
    );
  }

  void _validateCode() {
    if (_verificationCode == null) {
      setState(() {
        _statusMessage = 'Verification code not sent';
      });
      return;
    }

    final enteredCode = int.tryParse(_codeController.text);
    if (enteredCode != null && enteredCode == _verificationCode) {
      Navigator.of(context).pop();
      // Continue with the registration process
      _completeRegistration();
    } else {
      setState(() {
        _statusMessage = 'Invalid verification code';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid verification code')),
      );
    }
  }


  Future<void> _completeRegistration() async {
    setState(() {
      _isLoading = true;
    });
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final dob = _dobController.text;
    final address = _addressController.text;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Alphaapi.php'),
        //https://syfer001testing.000webhostapp.com/cloneapi/flutterinsert.php
      );
      request.fields['Registerdata'] = "requestby";
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['dob'] = dob;
      request.fields['address'] = address;
      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _profileImage!.path));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        if (responseData['status'] == 'success') {
          _clearFormFields();
          // Navigate to SignInPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect to server')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.blue,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _clearFormFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _dobController.clear();
    _addressController.clear();
    setState(() {
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Sign up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(height: 20),
              Text(
                "Create an account",
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 50,
                  )
                      : null,
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(_firstNameController, "First Name"),
              SizedBox(height: 10),
              _buildTextField(_lastNameController, "Last Name"),
              SizedBox(height: 10),
              _buildTextField(_emailController, "Email", inputType: TextInputType.emailAddress),
              SizedBox(height: 10),
              _buildPasswordField(_passwordController, "Password"),
              SizedBox(height: 10),
              _buildPasswordField(_confirmPasswordController, "Confirm Password"),
              SizedBox(height: 10),
              _buildDateField(context, _dobController, "Date of Birth"),
              SizedBox(height: 10),
              _buildTextField(_addressController, "Address"),
              SizedBox(height: 40),
              _isLoading
                  ? CircularProgressIndicator(color: Colors.black,)
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              if (_isSending)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_statusMessage),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText, {
        TextInputType inputType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        fillColor: Colors.black,
        hoverColor: Colors.black,
        focusColor: Colors.black,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        return null;
      },
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        fillColor: Colors.black,
        hoverColor: Colors.black,
        focusColor: Colors.black,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        return null;
      },
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        fillColor: Colors.black,
        hoverColor: Colors.black,
        focusColor: Colors.black,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        return null;
      },
      style: TextStyle(color: Colors.black),
    );
  }
}
