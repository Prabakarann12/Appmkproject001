import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/userdata.php?userId=${widget.userId}'),
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                    color: Colors.black,
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
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    // Navigate to Home Page if not already on it
                    if (ModalRoute.of(context)!.settings.name != '/') {
                      Navigator.pushNamed(context, '/');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    // Navigate to Settings Page if not already on it
                    if (ModalRoute.of(context)!.settings.name != '/settings') {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Customer Helpline'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    // Navigate to Customer Helpline Page if not already on it
                    if (ModalRoute.of(context)!.settings.name != '/customer-helpline') {
                      Navigator.pushNamed(context, '/customer-helpline');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    // Perform logout actions
                    // For example, clear user session and navigate to login page
                    // Replace with your actual logout implementation
                    if (ModalRoute.of(context)!.settings.name != '/login') {
                      Navigator.pushNamed(context,'/login');
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
