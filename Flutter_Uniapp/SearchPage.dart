import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'FaqPage.dart';
import 'SearchFilterPage.dart';
import 'FindPageUni.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Drawerpageuni.dart';
import 'HomePageUni.dart';
import 'TutorialsPage.dart';

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

  Widget _buildImageWithButton(String imageUrl, String country, String url) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 0.0, left: 5.0),
                height: 120,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
              ),
              SizedBox(height: 0),
              Text(
                country,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: SizedBox(
              width: 10,
              height: 35,
              child: TextButton(
                onPressed: () {
                  launchURL(url);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black, width: 2),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
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
      if (index == 4) { // Account button index
        _scaffoldKey.currentState?.openDrawer();
      }
      else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerApp()),
        );
      }
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FindUniPage(userId: widget.userId)),
        );
      }
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageUni(userId: widget.userId)),
        );
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Serach",
          style: const TextStyle(color: Colors.white),
        ),
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

      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Center(
            child: Container(
              height: 320, // Adjust height to accommodate the text fields and button
              width: 420, // Set the desired width
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2), // Black border with 2 pixels width
                borderRadius: BorderRadius.circular(15), // Same border radius as the Card
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color with 50% opacity
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0, // Set elevation to 0 since the Container handles the shadow
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
                          prefixIcon: Icon(Icons.public), // Icon for the first TextField
                          hintText: 'where are you studying abroad?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Space between the TextFields
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month), // Icon for the second TextField
                          hintText: 'Programe start date-Programe end date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Space between the TextFields
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.school), // Icon for the third TextField
                          hintText: 'Number of courses-Number of classmates',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
// Space between the TextFields and the button
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity, // Set the width to fill the parent
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SearchFilterPage(userId: widget.userId)),
                              );// Handle button press here
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white, // Set button text color to white
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
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ), Center(
            child: Container(
              height: 350,
              width: 420,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
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
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildImageWithButton(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/UsaSearchPg.jpg',
                              'USA',
                              'https://www.usnews.com/best-colleges/rankings/national-universities',
                            ),
                            _buildImageWithButton(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/AustraliaSearchPg.png',
                              'Australia',
                              'https://www.usnews.com/education/best-global-universities/australia-new-zealand',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildImageWithButton(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/UkSearchPg.jpg',
                              'UK',
                              'https://www.usnews.com/education/best-global-universities/united-kingdom',
                            ),
                            _buildImageWithButton(
                              'https://syfer001testing.000webhostapp.com/cloneapi/savefile/CanadaSearchPg.jpg',
                              'Canada',
                              'https://www.usnews.com/education/best-global-universities/slideshows/see-the-top-10-universities-in-canada',
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
                border: Border.all(color: Colors.black, width: 2), // Black border with 2 pixels width
                borderRadius: BorderRadius.circular(15), // Same border radius as the Card
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color with 50% opacity
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0, // Set elevation to 0 since the Container handles the shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0), // Adjusted padding
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
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'UK',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tuition fees:',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                border: Border.all(color: Colors.black, width: 2), // Black border with 2 pixels width
                borderRadius: BorderRadius.circular(15), // Same border radius as the Card
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color with 50% opacity
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0, // Set elevation to 0 since the Container handles the shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0), // Adjusted padding
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
                              style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'USA',
                              style: TextStyle(color:Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tuition fees:',
                              style: TextStyle(color:Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
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
                border: Border.all(color: Colors.black, width: 2), // Black border with 2 pixels width
                borderRadius: BorderRadius.circular(15), // Same border radius as the Card
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color with 50% opacity
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0, // Set elevation to 0 since the Container handles the shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0), // Adjusted padding
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
                              style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Australia',
                              style: TextStyle(color:Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tuition fees:',
                              style: TextStyle(color:Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
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
                border: Border.all(color: Colors.black, width: 2),
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
                color: Colors.white,
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
                                  angle: -45 * (pi / 180), // Convert -45 degrees to radians
                                  child: Icon(Icons.airplane_ticket_rounded, color: Colors.black), // Icon
                                ),
                                SizedBox(width: 8), // Space between the icon and text
                                Text(
                                  "Psst!",
                                  style: TextStyle(
                                    color: Colors.black,
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
                                color: Colors.black,
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
                                    MaterialPageRoute(builder: (context) => FaqPage(userId: widget.userId)),
                                  );
                                  // Handle Facebook login
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.black,
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
            icon: Icon(Icons.bookmark),
            label: 'Book',
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
  }
}
