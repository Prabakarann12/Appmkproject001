import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PropertyDetailsPage1.dart';
import 'PropertyDetailsPage2.dart';
import 'allRentalsPage.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> properties = [];
  bool isLoading = false;
  int currentPage = 1;
  final int propertiesPerPage = 8;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weeksController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bedsController = TextEditingController();
  final TextEditingController _bathsController = TextEditingController();
  final TextEditingController _sleepsController = TextEditingController();
  final TextEditingController _propertyIdCon = TextEditingController();
  final TextEditingController _streetName = TextEditingController();
  String selectedWeeks = 'Select Number of Weeks';
  String selectedBeds = 'Number of Beds';
  String selectedBaths = 'Number of Bathrooms';
  String selectedSleeps = 'Number of Sleeps';
  bool showDropdownWeeks = false;
  bool showDropdownBeds = false;
  bool showDropdownBaths = false;
  bool showDropdownSleeps = false;
  List<String> weeksOptions = ['1 Week', '2 Weeks', '3 Weeks', '4 Weeks', '5 Weeks', '6 Weeks', '7 Weeks', '8+ Weeks'];
  List<String> bedsOptions = ['Number of Beds', '1 Bed', '2 Beds', '3 Beds', '4 Beds', '5+ Beds'];
  List<String> bathsOptions = ['Number of Bathrooms', '1 Bath', '2 Baths', '3 Baths', '4 Baths', '5+ Baths'];
  List<String> sleepsOptions = ['No Preference', '1 Sleeps', '2 Sleeps', '3 Sleeps', '4 Sleeps', '5 Sleeps', '6 Sleeps', '7+ Sleeps'];
  RangeValues priceRange = RangeValues(0, 100000);
  bool _showFields = false;
  int _selectedIndex = 2;

  @override
  void dispose() {
    _dateController.dispose();
    _weeksController.dispose();
    _priceController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _sleepsController.dispose();
    _propertyIdCon.dispose();
    _streetName.dispose();
    _propertyIdCon.removeListener(_fetchData);
    _streetName.removeListener(_fetchData);
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _autoshowdata();
    _propertyIdCon.addListener(_fetchData);
    _streetName.addListener(_fetchData);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format to "yyyy-MM-dd"
      });
    }
  }
  Future<void> _autoshowdata() async {
    final String url = 'http://api-alpha.square1server.com/api/searchrental';

    final Map<String, String> queryParams = {
    };

    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          properties = data["search_resultsquery"];
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        _showDialog(context, "Error", "Failed to load data: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      _showDialog(context, "Error", "An error occurred: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _optionFetch() async {
    setState(() {
      _showFields = !_showFields;
    });
    await _fetchData();
  }

  Future<void> _fetchData() async {
    if (_propertyIdCon.text.isEmpty || _streetName.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String url = 'http://api-alpha.square1server.com/api/searchrental';

    final Map<String, String> queryParams = {
      'propertyidss': _propertyIdCon.text,
      'street': _streetName.text,
    };

    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          properties = data["search_resultsquery"];
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        _showDialog(context, "Error", "Failed to load data: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      _showDialog(context, "Error", "An error occurred: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _handleUpload() async {
    final String url = 'http://api-alpha.square1server.com/api/searchrental';

    String date = _dateController.text;
    String weeks = selectedWeeks == 'Select Number of Weeks' ? '' : selectedWeeks.split(' ')[0];
    String beds = selectedBeds.contains('Bed') ? selectedBeds.split(' ')[0] : '0';
    String baths = selectedBaths.contains('Bath') ? selectedBaths.split(' ')[0] : '0';
    String sleeps = selectedSleeps.contains('Sleeps') ? selectedSleeps.split(' ')[0] : '0';
    double minPrice = priceRange.start;
    double maxPrice = priceRange.end;

    final Map<String, String> queryParams = {
      'checkinDate': date,
      'numberOfWeeks': weeks,
      'beds': beds,
      'baths': baths,
      'sleepsUpTo': sleeps,
      'priceMin': minPrice.toString(),
      'priceMax': maxPrice.toString(),
    };

    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          properties = data["search_resultsquery"];
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        _showDialog(context, "Error", "Failed to load data: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      _showDialog(context, "Error", "An error occurred: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) { // Account button index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => allRental()),
        );
      }
      if (index == 1) { // Account button index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertyDetailsPage(property: {},)),
        );
      }
      if (index == 0) { // Index 1 is for the 'SALES' item
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>MainPage()),
        );
      }
    });
  }

  void _onPageChanged(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  List<Map<String, dynamic>> _getCurrentPageProperties() {
    int startIndex = (currentPage - 1) * propertiesPerPage;
    int endIndex = startIndex + propertiesPerPage;
    if (endIndex > properties.length) {
      endIndex = properties.length;
    }
    return properties.sublist(startIndex, endIndex).cast<Map<String, dynamic>>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0,
            child: Image.asset(
              'assets/rentalSearchTop.jpg', // Replace with your image path
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
          Positioned(
            top: 15, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/coldwellbankername_mobile.png', height: 60,),
              ],
            ),
            ),
          ),
          // Overlay ListView
          Positioned.fill(
            top: 300,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(27.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Check In:',
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: 'yyyy-MM-dd',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDropdownWeeks = !showDropdownWeeks;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedWeeks,
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                Icon(
                                  showDropdownWeeks ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (showDropdownWeeks)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: weeksOptions.map((week) {
                              return RadioListTile<String>(
                                title: Text(week),
                                value: week,
                                groupValue: selectedWeeks,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedWeeks = value!;
                                    showDropdownWeeks = false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      SizedBox(height: 20),
                      Text(
                        'Price Range:',
                        style: TextStyle(fontSize: 16),
                      ),
                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 100000,
                        divisions: 100,
                        labels: RangeLabels(
                          '\$${priceRange.start.toStringAsFixed(0)}',
                          '\$${priceRange.end.toStringAsFixed(0)}',
                        ),
                        activeColor: Colors.indigo[900],
                        onChanged: (RangeValues values) {
                          setState(() {
                            priceRange = values;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Min: \$${priceRange.start.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Max: \$${priceRange.end.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDropdownBeds = !showDropdownBeds;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedBeds,
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                Icon(
                                  showDropdownBeds ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (showDropdownBeds)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: bedsOptions.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: selectedBeds,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedBeds = value!;
                                    showDropdownBeds = false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDropdownBaths = !showDropdownBaths;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedBaths,
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                Icon(
                                  showDropdownBaths ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (showDropdownBaths)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: bathsOptions.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: selectedBaths,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedBaths = value!;
                                    showDropdownBaths = false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDropdownSleeps = !showDropdownSleeps;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedSleeps,
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                Icon(
                                  showDropdownSleeps ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (showDropdownSleeps)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: sleepsOptions.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: selectedSleeps,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedSleeps = value!;
                                    showDropdownSleeps = false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _optionFetch();
                        },
                        child: Text('Options'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 15),
                      Visibility(
                        visible: _showFields,
                        child: Column(
                          children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _propertyIdCon,
                                    decoration: InputDecoration(
                                      labelText: 'Property ID:',
                                      labelStyle: TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _streetName,
                                    decoration: InputDecoration(
                                      labelText: 'Street:',
                                      labelStyle: TextStyle(color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _handleUpload,
                        child: Text('UPDATE'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo[900],
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Showing ${currentPage * propertiesPerPage - (propertiesPerPage - 1)} to ${currentPage  * propertiesPerPage} of ${properties.length} results',
                        style: TextStyle(fontSize: 16),
                         ),
                     SizedBox(height: 10),
                     PaginationWidget(
                        currentPage: currentPage,
                        onPageChanged: _onPageChanged,
                        totalPages: (properties.length / propertiesPerPage).ceil(),
                          ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _getCurrentPageProperties().length,
                        itemBuilder: (context, index) {
                          final property = _getCurrentPageProperties()[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetailsPage2(property: property),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 12.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property['propertyname'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      property['propertyheadline'],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    property['imgPreview'] != null
                                        ? Image.network(property['imgPreview'])
                                        : Container(),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${property['city']}', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        ]
                                    ),
                                        Row(
                                          children: [
                                            Text(
                                          '${property['bedroom']} Bed(s)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
                                        ),
                                        SizedBox(width: 3),
                                        Text('|', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text('${property['bathroom']} Bath(s)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
                                        ),
                                        SizedBox(width: 3),
                                        Text('|', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text('${property['sleepupto']} Sleep(s)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
                                        ),
                                            ],
                                        ),

                                    ],
                                   ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        selectedItemColor: Colors.indigo[900],
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'SALES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'RENTALS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'FULL SITE',
          ),
        ],
      ),
    );
  }
}
class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationWidget({
    required this.currentPage,
    required this.onPageChanged,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    int startPage = (currentPage - 1) ~/ 3 * 3 + 1;
    int endPage = startPage + 2;
    if (endPage > totalPages) {
      endPage = totalPages;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        ...List.generate(endPage - startPage + 1, (index) {
          int pageNumber = startPage + index;
          return PaginationButton(
            pageNumber: pageNumber,
            isSelected: currentPage == pageNumber,
            onPageChanged: onPageChanged,
          );
        }),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}

class PaginationButton extends StatelessWidget {
  final int pageNumber;
  final bool isSelected;
  final ValueChanged<int> onPageChanged;

  const PaginationButton({
    required this.pageNumber,
    required this.isSelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
      child: GestureDetector(
        onTap: () => onPageChanged(pageNumber),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.indigo[900] : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            '$pageNumber',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}


