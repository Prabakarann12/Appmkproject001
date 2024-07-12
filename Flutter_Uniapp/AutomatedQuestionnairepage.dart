import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'HomePageUni.dart';
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
      home:Automatedquestionnairepage (), // Example userId
    );
  }
}

class Automatedquestionnairepage extends StatefulWidget {
  final int userId = 12;

  @override
  _AutomatedquestionnairepageState createState() =>
      _AutomatedquestionnairepageState();
}

class _AutomatedquestionnairepageState extends State<Automatedquestionnairepage> {
  int _selectedIndex = 0;
  double _budgetRange = 0;
  double _budgetRange1 = 0;
  String? _selectedProvince;
  String? _selectedLength;
  bool _isChecked = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) {
        // Account button index
      }
      if (index == 1) {}
      if (index == 0) {}
    });
  }

  TextEditingController _studyFieldController = TextEditingController();
  TextEditingController _additionalCriteriaController = TextEditingController();

  Future<void> _submitData() async {
    try {
      final url =
      Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Automatedquestionnairepg.php');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': widget.userId.toString(),
          'budget_range': _budgetRange.toString(),
          'province': _selectedProvince ?? '',
          'study_field': _studyFieldController.text,
          'program_length': _selectedLength ?? '',
          'scholarships_available': _isChecked ? '1' : '0',
          'application_fee': _budgetRange1.toString(),
          'additional_criteria': _additionalCriteriaController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle the response data as needed
      } else {
        // Handle the failure
      }
    } catch (e) {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
      return Scaffold(
        backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        appBar: AppBar(
          title: Text("Automated Questionnaire",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.grey),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tuition Budget",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      "0",
                      style: TextStyle(fontSize: 16,color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, ),
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
                     Text(
                      "100",
                      style: TextStyle(fontSize: 16,color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Province",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Province',
                  ),
                  value: _selectedProvince,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProvince = newValue;
                    });
                  },
                  items: <String>[
                    'Ontario',
                    'Manitoba',
                    'Nova Scotia',
                    'Alberta',
                    'Northwest Territories'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  "Study Field",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _studyFieldController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your study field',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Length Of Program",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Program Length',
                  ),
                  value: _selectedLength,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLength = newValue;
                    });
                  },
                  items: <String>[
                    '1 Year',
                    '2 Year',
                    '3 Year',
                    '4 Year',
                    '5 Year'
                  ]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  "Checkbox",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                      activeColor: Colors.cyan,
                    ),
                    Text('Scholarships Available'),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Application Fee",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      "0",
                      style: TextStyle(fontSize: 16,color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _budgetRange1,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _budgetRange1.round().toString(),
                        activeColor: Colors.green,
                        onChanged: (double value) {
                          setState(() {
                            _budgetRange1 = value;
                          });
                        },
                      ),
                    ),
                     Text(
                      "100",
                      style: TextStyle(fontSize: 16,color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Additional Criteria",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _additionalCriteriaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter any additional criteria',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: screenWidth >= 600 ? 600 : screenWidth - 40,
                  child: Card(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Study Abroad Program 1",
                            style: TextStyle(
                              color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "School: University X",
                            style: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Location: Canada",
                            style: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Brief Description: This programe offers a unique opportunity...",
                            style: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                              ),
                              child: Text("View Details"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: screenWidth >= 600 ? 600 : screenWidth - 40,
                  child: Card(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Study Abroad Program 2",
                            style: TextStyle(
                              color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "School: University Y",
                            style: TextStyle(
                              color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Location: Australia",
                            style: TextStyle(
                              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Brief Description: Explore the vibrant culture and academic...",
                            style: TextStyle(
                              color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                              ),
                              child: Text("View Details"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
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
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
      );
    },
    );
  }
}
