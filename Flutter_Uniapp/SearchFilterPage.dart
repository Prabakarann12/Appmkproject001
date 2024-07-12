import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FindPageUni.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      home: SearchFilterPage(userId: 1), // Example userId
    );
  }
}


class SearchFilterPage extends StatefulWidget {
  final int userId;
  const SearchFilterPage({super.key, required this.userId});
  @override
  _SearchFilterPageState createState() => _SearchFilterPageState();

}


class _SearchFilterPageState extends State<SearchFilterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  get userIdProfile => userIdProfile;
  int _selectedIndex = 0;
  bool _isCurrentLocationSelected = false;
  bool _isSearchLocationSelected = false;
  bool _isTodaySelected = false;
  bool _isTomorrowSelected = false;
  bool _isThisWeekSelected = false;
  bool _isThisMonthSelected = false;
  bool _isChooseDateSelected = false;
  bool _isDayTimeSelected = false;
  bool _isNightTimeSelected = false;
  bool _isSelectTimeSelected = false;
  bool _isConcertsSelected = false;
  bool _isPartiesSelected = false;
  bool _isListeningEventSelected = false;
  bool _isFestivalsSelected = false;
  bool _isToursSelected = false;
  bool _isApplyFilterSelected = false;
  double _budgetRange = 0;



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
  void _onCurrentLocationSelected() {
    setState(() {
      _isCurrentLocationSelected = !_isCurrentLocationSelected;

    });
  }

  void _onSearchLocationSelected() {
    setState(() {
      _isSearchLocationSelected = !_isSearchLocationSelected;
    });
  }

  void _onTodaySelected() {
    setState(() {
      _isTodaySelected = !_isTodaySelected;
    });
  }

  void _onTomorrowSelected() {
    setState(() {
      _isTomorrowSelected = !_isTomorrowSelected;
    });
  }

  void _onThisWeekSelected() {
    setState(() {
      _isThisWeekSelected = !_isThisWeekSelected;
    });
  }

  void _onThisMonthSelected() {
    setState(() {
      _isThisMonthSelected = !_isThisMonthSelected;
    });
  }

  void _onConcertsSelected() {
    setState(() {
      _isConcertsSelected = !_isConcertsSelected;
    });
  }

  void _onPartiesSelected() {
    setState(() {
      _isPartiesSelected = !_isPartiesSelected;
    });
  }

  void _onListeningEventSelected() {
    setState(() {
      _isListeningEventSelected = !_isListeningEventSelected;
    });
  }

  void _onFestivalsSelected() {
    setState(() {
      _isFestivalsSelected = !_isFestivalsSelected;
    });
  }

  void _onToursSelected() {
    setState(() {
      _isToursSelected = !_isToursSelected;
    });
  }

  void _onChooseDateSelected() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // change the primary color to green
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _isChooseDateSelected = true;
        // You can save the selected date here if needed
      });
    }
  }

  void _onDayTimeSelected() {
    setState(() {
      _isDayTimeSelected = !_isDayTimeSelected;
    });
  }

  void _onNightTimeSelected() {
    setState(() {
      _isNightTimeSelected = !_isNightTimeSelected;
    });
  }

  void _onSelectTimeSelected() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // change the primary color to green
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _isSelectTimeSelected = true;
        // You can save the selected time here if needed
      });
    }
  }

  void _onApplyFilterSelected() {
    setState(() {
      _isApplyFilterSelected = !_isApplyFilterSelected;
    });
    _applyFilters(); // Add this line to apply filters and store data
  }
  void _applyFilters() async {
    // Collect filter data
    Map<String, dynamic> filterData = {
      'currentLocation': _isCurrentLocationSelected,
      'searchLocation': _isSearchLocationSelected,
      'today': _isTodaySelected,
      'tomorrow': _isTomorrowSelected,
      'thisWeek': _isThisWeekSelected,
      'thisMonth': _isThisMonthSelected,
      'chooseDate': _isChooseDateSelected,
      'dayTime': _isDayTimeSelected,
      'nightTime': _isNightTimeSelected,
      'selectTime': _isSelectTimeSelected,
      'concerts': _isConcertsSelected,
      'parties': _isPartiesSelected,
      'listeningEvent': _isListeningEventSelected,
      'festivals': _isFestivalsSelected,
      'tours': _isToursSelected,
      'budgetRange': _budgetRange,
    };

    // Send data to the server
    final response = await http.post(
      Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/filtterflutter.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(filterData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        print('Filter data stored successfully');
      } else {
        print('Error storing filter data: ${responseData['message']}');
      }
    } else {
      print('Failed to connect to the server');
    }
  }


  void _resetFilter() {
    setState(() {
      _isCurrentLocationSelected = false;
      _isSearchLocationSelected = false;
      _isTodaySelected = false;
      _isTomorrowSelected = false;
      _isThisWeekSelected = false;
      _isThisMonthSelected = false;
      _isChooseDateSelected = false;
      _isDayTimeSelected = false;
      _isNightTimeSelected = false;
      _isSelectTimeSelected = false;
      _isConcertsSelected = false;
      _isPartiesSelected = false;
      _isListeningEventSelected = false;
      _isFestivalsSelected = false;
      _isToursSelected = false;
      _budgetRange = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child)
    {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            'Search Filters', style: TextStyle(color: Colors.white),),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Location Preferences",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      backgroundColor: _isCurrentLocationSelected
                          ? Colors.green
                          :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    ),
                    onPressed: _onCurrentLocationSelected,
                    child: const Text('Use current location'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      backgroundColor: _isSearchLocationSelected ? Colors.green
                          :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    ),
                    onPressed: _onSearchLocationSelected,
                    child: const Text('Search location'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  "Select Date",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isTodaySelected
                              ? Colors.green
                              : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onTodaySelected,
                        child: const Text('Today'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isTomorrowSelected
                              ? Colors.green
                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onTomorrowSelected,
                        child: const Text('Tomorrow'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isThisWeekSelected
                              ? Colors.green
                              : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onThisWeekSelected,
                        child: const Text('This Week'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isThisMonthSelected
                              ? Colors.green
                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onThisMonthSelected,
                        child: const Text('This Month'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isChooseDateSelected
                              ? Colors.green
                              : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onChooseDateSelected,
                        child: const Text('Choose Date'),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  "Select Time",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      backgroundColor: _isDayTimeSelected
                          ? Colors.green
                          : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    ),
                    onPressed: _onDayTimeSelected,
                    child: const Text('Day Time'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      backgroundColor: _isNightTimeSelected
                          ? Colors.green
                          :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    ),
                    onPressed: _onNightTimeSelected,
                    child: const Text('Night Time'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      backgroundColor: _isSelectTimeSelected
                          ? Colors.green
                          : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    ),
                    onPressed: _onSelectTimeSelected,
                    child: const Text('Select Time'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  "Event Type",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isConcertsSelected
                              ? Colors.green
                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onConcertsSelected,
                        child: const Text('Concerts'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isPartiesSelected
                              ? Colors.green
                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onPartiesSelected,
                        child: const Text('Parties'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isListeningEventSelected ? Colors
                              .green :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onListeningEventSelected,
                        child: const Text('Listening Events'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isFestivalsSelected
                              ? Colors.green
                              :themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onFestivalsSelected,
                        child: const Text('Festivals'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                          backgroundColor: _isToursSelected
                              ? Colors.green
                              : themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                        onPressed: _onToursSelected,
                        child: const Text('Tours'),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "0",
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Slider(
                        value: _budgetRange,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _budgetRange.round().toString(),
                        activeColor: Colors.green,
                        onChanged: (double value) {
                          setState(() {
                            _budgetRange = value;
                          });
                        },
                      ),
                    ),
                    const Text(
                      "100",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  "Apply Filter",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                    backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  ),
                  onPressed: _onApplyFilterSelected,
                  child: const Text('Apply Filter'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  onPressed: _resetFilter,
                  child: const Text('Reset Filter'),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
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
    },
    );
  }
}
