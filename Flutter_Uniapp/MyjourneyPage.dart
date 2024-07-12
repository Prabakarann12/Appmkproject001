import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      home: Myjourneypage(), // Example userId
    );
  }
}

class Myjourneypage extends StatefulWidget {
  const Myjourneypage({super.key});

  @override
  _Myjourneypage createState() => _Myjourneypage();
}

class _Myjourneypage extends State<Myjourneypage> {
  int _selectedIndex = 0;
  bool _isChecked = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child)
    {
      return Scaffold(
        backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        appBar: AppBar(
          title: Text(
            "StudyConnect",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Handle notification icon press
              },
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Handle settings icon press
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Admissions",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Follow the initial step to get admitted to a university abroad. Click below to proceed to the next step.",
                  style: TextStyle(fontSize: 15,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Adjust the horizontal padding as needed
                child: TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    // Set the width and height of the buttons
                    backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    foregroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Next step"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Document gathering",
                  style: TextStyle(
                    color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Check list of required documents: Medical records, Bank statements, study plan and more. make the checkboxes when you gathered each document.",
                  style: TextStyle(fontSize: 15,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
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
                    Text('Medical Repords',style: TextStyle(color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isChecked1,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked1 = value!;
                        });
                      },
                      activeColor: Colors.cyan,
                    ),
                    Text('Bank Statements',style: TextStyle(color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked2 = value!;
                        });
                      },
                      activeColor: Colors.cyan,
                    ),
                    Text('Study Plan',style: TextStyle(color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Adjust the horizontal padding as needed
                child: TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    // Set the width and height of the buttons
                    backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    foregroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Next step"),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "IMM Forms",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Find and fill out the necessary immigration froms. get guidence on completing the forms accurately",
                  style: TextStyle(fontSize: 15,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Adjust the horizontal padding as needed
                child: TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    // Set the width and height of the buttons
                    backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Next step"),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Visa Submission",
                  style: TextStyle(
                    color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Instruction on how to submite Visa application. tip on where and how to submit the application",
                  style: TextStyle(fontSize: 15,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Adjust the horizontal padding as needed
                child: TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    // Set the width and height of the buttons
                    backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Confirm Submission"),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "After Process",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Details on what to expect after submitting your Visa application. processing time, interview preparation and post-app roval actions.  ",
                  style: TextStyle(fontSize: 15,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // Adjust the horizontal padding as needed
                child: TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 45),
                    // Set the width and height of the buttons
                    backgroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    foregroundColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Complete Visa Process"),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Find',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_rounded),
              label: 'Document',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Grorp',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      );
    },
    );
  }
}
