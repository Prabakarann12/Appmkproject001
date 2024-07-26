import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'SignInPage.dart';
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
      home: DrawerPage(userId: 1), // Example userId
    );
  }
}

class DrawerPage extends StatefulWidget {
  final int userId;

  const DrawerPage({Key? key, required this.userId}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Drawer Page'),
          ),
          drawer: CustomDrawer(userDataFuture: fetchUserData()),
          body: Center(
            child: Text('Drawer Page Content'),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Alphaapi.php?requestby=showuserdata&userId=${widget.userId}'),
      //https://syfer001testing.000webhostapp.com/cloneapi/userdata.php?userId=${widget.userId}
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}

class CustomDrawer extends StatelessWidget {
  final Future<Map<String, dynamic>> userDataFuture;

  CustomDrawer({required this.userDataFuture});

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data from SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Drawer(
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          child: FutureBuilder<Map<String, dynamic>>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final userData = snapshot.data!;
                final imageUrl = 'https://syfer001testing.000webhostapp.com/cloneapi/${userData['file_path']}';

                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 40,
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${userData['first_name']} ${userData['last_name']}',
                            style: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                          color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        //Navigator.pop(context); // Step back in the page
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.bookmark, color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                      title: Text('Bookmark', style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
                      onTap: () {
                        // Add your bookmark handling logic here
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                      title: Text('Customer Helpline', style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        // Navigate to Customer Helpline Page if not already on it
                        if (ModalRoute.of(context)!.settings.name != '/customer-helpline') {
                          Navigator.pushNamed(context, '/customer-helpline');
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                      title: Text('Logout', style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text('Sign out of your account?', style: TextStyle(fontSize: 20,color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black),),
                              actions: [
                                TextButton(
                                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Dismiss the dialog
                                  },
                                ),
                                TextButton(
                                  child: Text('Logout', style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Dismiss the dialog
                                    _logout(context); // Perform the logout action
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
