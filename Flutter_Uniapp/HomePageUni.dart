import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uniflutterprot01/TutorialsPage.dart';
import 'dart:convert';
import 'SearchPage.dart';
import 'FindPageUni.dart';
import 'Drawerpageuni.dart';
import 'NetworkPage.dart';
import 'ConsultantsPage.dart';
import 'CollegePage.dart';
import 'SchoolPage.dart';
import 'AlumniPage.dart';
import 'DocumentPage.dart';
import 'SettingsPage.dart';
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
      home: HomePageUni(userId: 1), // Example userId
    );
  }
}
class HomePageUni extends StatefulWidget {
  final int userId;

  const HomePageUni({super.key, required this.userId});

  @override
  _HomePageUniState createState() => _HomePageUniState();
}

class _HomePageUniState extends State<HomePageUni> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  get userIdProfile => userIdProfile;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) {
        _scaffoldKey.currentState?.openDrawer();
      } else if (index == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FindUniPage(userId: widget.userId)),);
      }
      else if (index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageUni(userId: widget.userId)),);
      }
      else if (index == 2) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoListScreen()),);
      }
      else if (index == 3) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(userId: widget.userId)),);
      }
    });
  }

  void _navigateToListView(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page = NetworkPage();
        break;
      case 1:
        page = ConsultantsPage();
        break;
      case 2:
        page = AlumniPage();
        break;
      case 3:
        page = SchoolPage();
        break;
      case 4:
        page = CollegePage();
        break;
      default:
        page = NetworkPage(); // Default page
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
  Future<Map<String, dynamic>> fetchUserData(int id) async {
    final response = await http.get(Uri.parse(
        'https://syfer001testing.000webhostapp.com/cloneapi/Alphaapi.php?requestby=showuserdata&id=$id'));
         //https://syfer001testing.000webhostapp.com/cloneapi/showdataflutter02.php?id=$id

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text("Explore", style: TextStyle(color: Colors.white,),),
            elevation: 0,
            backgroundColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, size: 20.0, color: Colors.white,),
            ),
          ),
          body: FutureBuilder<Map<String, dynamic>>(
            future: fetchUserData(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final userData = snapshot.data!;
                final imageUrl = 'https://syfer001testing.000webhostapp.com/cloneapi/' +
                    userData['file_path'];

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Text(
                          "Discover programs",
                          style: TextStyle(fontSize: 20.0,
                            color: themeNotifier.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  itemCount: 2,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    // List of images or different content for each card
                                    List<Map<String, dynamic>> cardContent = [
                                      {
                                        'image': 'https://syfer001testing.000webhostapp.com/cloneapi/savefile/homepgdp1.jpg',
                                        'title': 'School',
                                        'description': 'Description 1',
                                        'checklist': 'Check 1',
                                        'icon1': Icons.checklist,
                                        'icon1Text': 'Checklist 1',
                                        'icon2': Icons.star,
                                        'icon2Text': 'Top',
                                      },
                                      {
                                        'image': 'https://syfer001testing.000webhostapp.com/cloneapi/savefile/homepgdp2.jpg',
                                        'title': 'Documents',
                                        'description': 'Description 2',
                                        'checklist': 'Check 2',
                                        'icon1': Icons.picture_as_pdf,
                                        'icon1Text': 'PDF',
                                        'icon2': Icons.description,
                                        'icon2Text': 'Docs',
                                      },
                                    ];
                                    return Container(
                                      height: 230, width: 260, margin: EdgeInsets.all(19.5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Card(
                                        color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.0,
                                              left: 10.0, right: 10.0, bottom: 10.0),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(15.0),
                                                child: Image.network(cardContent[index]['image']!, fit: BoxFit.cover, height: 150, width: double.infinity,),
                                              ),
                                              Positioned(
                                                bottom: 55, left: 0, right: 110,
                                                child: Container(
                                                  height: 50,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        // Add your specific logic for each card here
                                                        switch (index) {
                                                          case 0:
                                                            print(
                                                                'Card 1 clicked');
                                                            break;
                                                          case 1:
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => DocumentPage(userId: widget.userId)),
                                                            );
                                                            break;
                                                        }
                                                      },
                                                      style: TextButton
                                                          .styleFrom(
                                                        backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                                        side: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                                                      ),
                                                      child: Text(
                                                        cardContent[index]['title']!,
                                                        style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 10,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      cardContent[index]['icon1'],
                                                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      cardContent[index]['icon1Text']!, style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 110,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      cardContent[index]['icon2'],
                                                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      cardContent[index]['icon2Text']!,
                                                      style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              ListTile(
                                title: Text("Connection", style: TextStyle(
                                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                              ),
                              SizedBox(
                                height: 105,
                                child: ListView.builder(
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    List<String> imagePaths = [
                                      'assets/NetworkIcon.png',
                                      'assets/ConsultantsIcon.png',
                                      'assets/AluminiIcon.png',
                                      'assets/SchoolIcon.png',
                                      'assets/CollegeIcon.png'
                                    ];
                                    return InkWell(
                                      onTap: () =>
                                          _navigateToListView(context, index),
                                      child: Container(
                                        width: 77.56,
                                        height: 77,
                                        margin: const EdgeInsets.all(13.65),
                                        child: Image.asset(
                                          imagePaths[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text("My Profile", style: TextStyle(
                                  color: themeNotifier.themeMode ==
                                      ThemeMode.dark ? Colors.white : Colors.black,),),
                              ),
                              Center(
                                child: Container(
                                  height: 240 * 0.97,
                                  width: 420 * 0.97,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeNotifier.themeMode ==
                                            ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    color: themeNotifier.themeMode ==
                                        ThemeMode.dark ? Colors.black : Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Image.network(imageUrl, width: 87, height: 131, fit: BoxFit.cover,),
                                          SizedBox(width: 16),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                'Name: ${userData['first_name']} ${userData['last_name']}',
                                                style: TextStyle(fontSize: 15,
                                                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Email: ${userData['email']}',
                                                style: TextStyle(fontSize: 15,
                                                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'DOB: ${userData['dob']}',
                                                style: TextStyle(fontSize: 15,
                                                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Address: ${userData['address']}',
                                                style: TextStyle(fontSize: 15, color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Center(child: MaterialButton(minWidth: 150, height: 45,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(userId: widget.userId)),);
                                },
                                color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text("View All", style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0,),
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
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
            items: const <BottomNavigationBarItem>[

              BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Explor',),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find',),
              BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Tutorials',),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting',),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account',),

            ],
          ),
          drawer: CustomDrawer(userDataFuture: fetchUserData(widget.userId),),
        );
      },
    );
  }
}
