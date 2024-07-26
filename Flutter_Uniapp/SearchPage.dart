import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uniflutterprot01/SettingsPage.dart';
import 'FaqPage.dart';
import 'SearchFilterPage.dart';
import 'FindPageUni.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Drawerpageuni.dart';
import 'HomePageUni.dart';
import 'ThemeNotifier.dart';
import 'TutorialsPage.dart';

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
      home: SearchPage(userId: 1), // Example userId
    );
  }
}
class SearchPage extends StatefulWidget {
  final int userId;

  const SearchPage({super.key, required this.userId});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  get userIdProfile => userIdProfile;


  Widget _buildImageWithButton(String imageUrl, String title, String url) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0), // Reduced top padding for image
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, height: 100,
                width: 180), // Adjusted height for the image
          ),
        ),
        SizedBox(height: 2), // Space between image and button
        ElevatedButton(
          onPressed: () async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text("Learn More"),
        ),
        SizedBox(height: 2), // Space between button and text
        Text(title),
      ],
    );
  }
  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) { _scaffoldKey.currentState?.openDrawer();
      }
      else if (index == 2) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoListScreen()),);
      }
      else if (index == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FindUniPage(userId: widget.userId)),);
      }
      else if(index == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageUni(userId: widget.userId)),);
      }
      else if(index == 3) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(userId: widget.userId)),);
      }
    });
  }
  Future<Map<String, dynamic>> fetchUserData(int id) async {
    final response = await http.get(Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/showdataflutter02.php?id=$id'));

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
        backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        appBar: AppBar(title: Text("Serach", style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, size: 20.0, color: Colors.white,),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Center(
              child: Container(
                height: 320, width: 420,
                // Set the desired width
                decoration: BoxDecoration(
                  border: Border.all(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                  // Black border with 2 pixels width
                  borderRadius: BorderRadius.circular(15),
                  // Same border radius as the Card
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // Shadow color with 50% opacity
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  elevation: 0,
                  // Set elevation to 0 since the Container handles the shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.public,color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                            // Icon for the first TextField
                            hintText: 'where are you studying abroad?',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            fillColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            hoverColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10), // Space between the TextFields
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                            hintText: 'Programe start date-Programe end date',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 1.0)
                            ),
                            focusColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            hoverColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            fillColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10), // Space between the TextFields
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.school,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                            hintText: 'Number of courses-Number of classmates',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            fillColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            focusColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            hoverColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10),
// Space between the TextFields and the button
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            // Set the width to fill the parent
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      SearchFilterPage(userId: widget.userId)),
                                ); // Handle button press here
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white, // Set button text color to white
                              ),
                              child: Text(
                                "Search",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Top University",
              style: TextStyle(
                color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),

            Center(
              child: Container(
                height: 240, // Set the desired height
                width: 420, // Set the desired width
                decoration: BoxDecoration(
                  border: Border.all(color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,width: 2),
                  // Black border with 2 pixels width
                  borderRadius: BorderRadius.circular(15),
                  // Same border radius as the Card
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // Shadow color with 50% opacity
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  elevation: 0,
                  // Set elevation to 0 since the Container handles the shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    // Adjusted padding
                    child: Stack(
                      children: [
                        // Image view on top of the card
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/OxfordSerachPG02.jpg',
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                        // Align text views to the left with margin
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Oxford University',
                                style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'UK',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Tuition fees:',
                                style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                height: 240, // Set the desired height
                width: 420, // Set the desired width
                decoration: BoxDecoration(
                  border: Border.all(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                  // Black border with 2 pixels width
                  borderRadius: BorderRadius.circular(15),
                  // Same border radius as the Card
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // Shadow color with 50% opacity
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  elevation: 0,
                  // Set elevation to 0 since the Container handles the shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    // Adjusted padding
                    child: Stack(
                      children: [
                        // Image view on top of the card
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/HarvardUniSearchPg02.jpg',
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                        // Align text views to the left with margin
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harvard University',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'USA',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Tuition fees:',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                height: 240, // Set the desired height
                width: 420, // Set the desired width
                decoration: BoxDecoration(
                  border: Border.all(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                  // Black border with 2 pixels width
                  borderRadius: BorderRadius.circular(15),
                  // Same border radius as the Card
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // Shadow color with 50% opacity
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Card(
                  color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  elevation: 0,
                  // Set elevation to 0 since the Container handles the shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    // Adjusted padding
                    child: Stack(
                      children: [
                        // Image view on top of the card
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/sydneyuniOgsearch02.jpg',
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                        // Align text views to the left with margin
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sydney University',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Australia',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Tuition fees:',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),
            Center(
              child: Container(
                height: 200,
                width: 380,
                decoration: BoxDecoration(
                  border: Border.all(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
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
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Transform.rotate(
                                    angle: -45 * (pi / 180),
                                    // Convert -45 degrees to radians
                                    child: Icon(Icons.airplane_ticket_rounded, color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,), // Icon
                                  ),
                                  SizedBox(width: 8),
                                  // Space between the icon and text
                                  Text(
                                    "Psst!",
                                    style: TextStyle(
                                      color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Unlock exclusive and discounts for your "
                                    "study abroad journey. "
                                    "Join the UniStiudy community now!",
                                style: TextStyle(
                                  color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center, // Center the text
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          FaqPage(userId: widget.userId)),
                                    );
                                    // Handle Facebook login
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                    foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                  ),
                                  child: Text("Join Now"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ... add more cards here for remaining items
          ],
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
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'Explor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Find',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Tutorials',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
        drawer: CustomDrawer(
          userDataFuture: fetchUserData(widget.userId),
        ),
      );
    },
    );
  }
}
