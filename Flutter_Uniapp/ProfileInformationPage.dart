import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'ThemeNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileInformationPage(userId: 1), // Example userId
    );
  }
}

class ProfileInformationPage extends StatefulWidget {
  final int userId;
  ProfileInformationPage({required this.userId});

  @override
  _ProfileInformationPageState createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  XFile? _newImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _addressController = TextEditingController();

    fetchUserData(widget.userId).then((userData) {
      _firstNameController.text = userData['first_name'];
      _lastNameController.text = userData['last_name'];
      _emailController.text = userData['email'];
      _dobController.text = userData['dob'];
      _addressController.text = userData['address'];
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) {
        _scaffoldKey.currentState?.openDrawer();
      } else if (index == 1) {
        // Handle Find button tap
      } else if (index == 0) {
        // Handle Explore button tap
      } else if (index == 2) {
        // Handle Tutorials button tap
      }
    });
  }

  Future<Map<String, dynamic>> fetchUserData(int id) async {
    final response = await http.get(Uri.parse(
        'https://syfer001testing.000webhostapp.com/cloneapi/showdataflutter02.php?id=$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUserDetails() async {
    final Uri uploadUri = Uri.parse(
        'https://syfer001testing.000webhostapp.com/cloneapi/uniupdatepageapi.php');
            //https://syfer001testing.000webhostapp.com/cloneapi/uniupdatepageapi.php

    try {
      final request = http.MultipartRequest('POST', uploadUri);

      // Add the new image file if it exists
      if (_newImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _newImage!.path,
          contentType: MediaType('image', 'jpg'),
        ));
      }

      // Add the user data fields
      request.fields['edituserdata'] = 'requestby';
      request.fields['id'] = widget.userId.toString();
      request.fields['first_name'] = _firstNameController.text;
      request.fields['last_name'] = _lastNameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['dob'] = _dobController.text;
      request.fields['address'] = _addressController.text;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark
              ? Colors.black
              : Colors.white,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Information",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "View and edit your profile details",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
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
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: themeNotifier.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _newImage = XFile(pickedFile.path);
                              });
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: _newImage != null
                                      ? Image.file(
                                    File(_newImage!.path),
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  )
                                      : FutureBuilder<Map<String, dynamic>>(
                                    future:
                                    fetchUserData(widget.userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}');
                                      } else {
                                        final userData =
                                        snapshot.data!;
                                        final imageUrl =
                                            'https://syfer001testing.000webhostapp.com/cloneapi/' +
                                                userData['file_path'];
                                        return Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 150,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildTextField(_firstNameController, "First Name", themeNotifier),
                      SizedBox(height: 20.0),
                      _buildTextField(_lastNameController, "Last Name", themeNotifier),
                      SizedBox(height: 20.0),
                      _buildTextField(_emailController, "Email", themeNotifier),
                      SizedBox(height: 20.0),
                      _buildTextField(_dobController, "Date of Birth", themeNotifier),
                      SizedBox(height: 20.0),
                      _buildTextField(_addressController, "Address", themeNotifier),
                      SizedBox(height: 40.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: updateUserDetails,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, ThemeNotifier themeNotifier) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      style: TextStyle(
        color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
      ),
    );
  }
}
