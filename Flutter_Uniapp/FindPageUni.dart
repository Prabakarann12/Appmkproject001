import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uniflutterprot01/SettingsPage.dart';
import 'HomePageUni.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Drawerpageuni.dart';
import 'ThemeNotifier.dart';
import 'TutorialsPage.dart';
import 'SearchPage.dart';
import 'package:intl/intl.dart';
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
      home:FindUniPage(userId: 1,), // Example userId
    );
  }
}
class FindUniPage extends StatefulWidget {
  final int userId;
  const FindUniPage({super.key, required this.userId});
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
  get userIdProfile => userIdProfile;
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
  DateTime _focusedDay = DateTime.now();
  Set<DateTime> _selectedDays = {};
  bool _isIconPressed = false;

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
              builder: (context) => VideoListScreen()),
        );
      }
      else if  (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchPage(userId: widget.userId)),
        );
      }
      else if  (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageUni(userId: widget.userId)),
        );
      }
      else if  (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingsPage(userId: widget.userId)),
        );
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

  void _onTime9Selected() {setState(() {_isTime9Selected = !_isTime9Selected;});
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
    return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child)
    {
      return SafeArea(
        child: Scaffold(
          backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text(
              "Find Program",
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
                       Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 20),
                        child: Text(
                          "UniStudy Calendar",
                          style: TextStyle(
                            color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                      color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                    foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    backgroundColor: _isTime7Selected ? Colors
                                        .green :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                  ),
                                  onPressed: _onTime7Selected,
                                  child: const Text('15 min'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    backgroundColor: _isTime8Selected ? Colors
                                        .green : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                  ),
                                  onPressed: _onTime8Selected,
                                  child: const Text('30 min'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                    backgroundColor: _isTime9Selected ? Colors
                                        .green :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 530,
                    width: 420,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Card(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0, top: 10.0),
                                        child: Icon(Icons.date_range),
                                      ),
                                      SizedBox(width: 5),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0, top: 10.0),
                                        child: Text(
                                          "Pick a day",
                                          style: TextStyle(
                                            color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: _isIconPressed
                                          ? Colors.red
                                          : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDays.clear();
                                        _isIconPressed = true;
                                      });

                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        setState(() {
                                          _isIconPressed = false;
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TableCalendar(
                                firstDay: DateTime.utc(2021, 1, 1),
                                lastDay: DateTime.utc(2030, 12, 31),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) {
                                  return _selectedDays.contains(day);
                                },
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                ),
                                calendarStyle: CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  defaultTextStyle: TextStyle(
                                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                  ),
                                  selectedTextStyle: TextStyle(
                                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                  ),
                                ),
                                daysOfWeekStyle: const DaysOfWeekStyle(
                                  weekdayStyle: TextStyle(color: Colors.blue),
                                  weekendStyle: TextStyle(color: Colors.red),
                                ),
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    if (_selectedDays.contains(selectedDay)) {
                                      _selectedDays.remove(selectedDay);
                                    } else if (_selectedDays.length < 10) {
                                      _selectedDays.add(selectedDay);
                                    }
                                    _focusedDay = focusedDay;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Selected Days: ${_selectedDays.map((date) => DateFormat('yyyy-MM-dd').format(date)).join(', ')}',
                                style: TextStyle(
                                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
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
                      border: Border.all(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,width: 2),
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
                                        color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          backgroundColor: _isTime1Selected
                                              ? Colors.green
                                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          backgroundColor: _isTime2Selected
                                              ? Colors.green
                                              : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          backgroundColor: _isTime3Selected
                                              ? Colors.green
                                              : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          backgroundColor: _isTime4Selected
                                              ? Colors.green
                                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          backgroundColor: _isTime5Selected
                                              ? Colors.green
                                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          backgroundColor: _isTime6Selected
                                              ? Colors.green
                                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
                      foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
            backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal),
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
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
          key: _scaffoldKey,
        ),
      );
    },
    );
  }
}
