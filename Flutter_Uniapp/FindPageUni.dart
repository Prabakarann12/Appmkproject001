import 'package:flutter/material.dart';
import 'HomePageUni.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FindUniPage(),

    );
  }
}

class FindUniPage extends StatefulWidget {


  @override
  _FindUniPageState createState() => _FindUniPageState();
}

Future<Map<String, dynamic>> fetchUserData(int id) async {
  final response = await http.get(Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/showdataflutter02.php?id=$id'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

class _FindUniPageState extends State<FindUniPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;
  bool _isTime1Selected = false;
  bool _isTime2Selected = false;
  bool _isTime3Selected = false;
  bool _isTime4Selected = false;
  bool _isTime5Selected = false;
  bool _isTime6Selected = false;
  bool _isTime7Selected = false;
  bool _isTime8Selected = false;
  bool _isTime9Selected = false;

  get userIdProfile => userIdProfile;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) { // Account button index
        _scaffoldKey.currentState?.openDrawer();
      }
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FindUniPage()),
        );
      }
      if (index == 0) {

      }
    });
  }

  void _onTime1Selected() {
    setState(() {
      _isTime1Selected = !_isTime1Selected;
    });
  }

  void _onTime2Selected() {
    setState(() {
      _isTime2Selected = !_isTime2Selected;
    });
  }

  void _onTime3Selected() {
    setState(() {
      _isTime3Selected = !_isTime3Selected;
    });
  }

  void _onTime4Selected() {
    setState(() {
      _isTime4Selected = !_isTime4Selected;
    });
  }

  void _onTime5Selected() {
    setState(() {
      _isTime5Selected = !_isTime5Selected;
    });
  }

  void _onTime6Selected() {
    setState(() {
      _isTime6Selected = !_isTime6Selected;
    });
  }

  void _onTime7Selected() {
    setState(() {
      _isTime7Selected = !_isTime7Selected;
    });
  }

  void _onTime8Selected() {
    setState(() {
      _isTime8Selected = !_isTime8Selected;
    });
  }

  void _onTime9Selected() {
    setState(() {
      _isTime9Selected = !_isTime9Selected;
    });
  }

  void _resetFilter() {
    setState(() {
      _isTime1Selected = false;
      _isTime2Selected = false;
      _isTime3Selected = false;
      _isTime4Selected = false;
      _isTime5Selected = false;
      _isTime6Selected = false;
      _isTime7Selected = false;
      _isTime8Selected = false;
      _isTime9Selected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Find Program",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/findpgetopnav.png'),
                      radius: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 20),
                      child: Text(
                        "UniStudy Calendar",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 140,
                  width: 420,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10.0),
                                child: Icon(Icons.calendar_today_rounded),
                              ),
                              SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10.0),
                                child: Text(
                                  "Choose Duration",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _isTime7Selected ? Colors
                                      .green : Colors.black,
                                ),
                                onPressed: _onTime7Selected,
                                child: const Text('15 min'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _isTime8Selected ? Colors
                                      .green : Colors.black,
                                ),
                                onPressed: _onTime8Selected,
                                child: const Text('30 min'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _isTime9Selected ? Colors
                                      .green : Colors.black,
                                ),
                                onPressed: _onTime9Selected,
                                child: const Text('60 min'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 250,
                  width: 420,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10.0),
                                child: Icon(Icons.date_range),
                              ),
                              SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10.0),
                                child: Text(
                                  "Choose Duration",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
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


              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 270,
                  width: 420,
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
                      // Set elevation to 0 since the Container handles the shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0, top: 10.0),
                                  // Add padding around the icon
                                  child: Icon(Icons.access_time_filled_sharp),
                                ),
                                SizedBox(width: 5),
                                // Add some space between the icon and text
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0, top: 10.0),
                                  // Add padding around the text
                                  child: Text(
                                    "Select time",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    // Set the fixed width for the button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _isTime1Selected
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      onPressed: _onTime1Selected,
                                      child: Text('9:00pm'),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 120,
                                    // Set the fixed width for the button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _isTime2Selected
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      onPressed: _onTime2Selected,
                                      child: Text('10:00pm'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    // Set the fixed width for the button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _isTime3Selected
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      onPressed: _onTime3Selected,
                                      child: Text('11:30pm'),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 120,
                                    // Set the fixed width for the button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _isTime4Selected
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      onPressed: _onTime4Selected,
                                      child: Text('1:00pm'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    // Set the fixed width for the button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _isTime5Selected
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      onPressed: _onTime5Selected,
                                      child: Text('3:00pm'),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  SizedBox(
                                    width: 120,
                                    // Set the fixed width for the button
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _isTime6Selected
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      onPressed: _onTime6Selected,
                                      child: Text('4:45pm'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )


                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _resetFilter,
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
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
              label: 'Explore',
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
        key: _scaffoldKey,


      ),
    );
  }
}

