import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AutomatedQuestionnairepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaqPage(),
    );
  }
}

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextEditingController _studyController = TextEditingController();
  TextEditingController _careerController = TextEditingController();
  TextEditingController _culturalController = TextEditingController();
  TextEditingController _personalController = TextEditingController();

  Future<void> _submitForm() async {
    String url = 'https://syfer001testing.000webhostapp.com/cloneapi/faquni.php';

    try {
      var response = await http.post(Uri.parse(url), body: {
        'FAQstudy': _studyController.text,
        'FAQcareer': _careerController.text,
        'FAQcultural': _culturalController.text,
        'FAQpersonal': _personalController.text,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data['message']);
        _studyController.clear();
        _careerController.clear();
        _culturalController.clear();
        _personalController.clear();
        // Optionally, you can navigate to a success screen or handle the response here
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Your App Title'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                "HomePage Buttons",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Automatedquestionnairepage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  alignment: Alignment.centerLeft, // Align text to the left
                ),
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text("Automated Questionnaire"),
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Resources"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("My Journey"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Program Search"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("My Task"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Tools"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Networks"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Set the width and height of the buttons
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Communications"),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 45), // Adjust the width and height as needed
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("My Files"),
                ),
              ),
            ),


            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                "Answering Study Abroad Goals",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 420),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "What are your study abroad goals?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _studyController,
                          decoration: InputDecoration(
                            hintText: 'Enter your goal here....',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height * 0.02,
                                horizontal: MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "What are your career aspirations?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _careerController,
                          decoration: InputDecoration(
                            hintText: 'Enter your aspiration here....',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height * 0.02,
                                horizontal: MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "What are your cultural interests?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _culturalController,
                          decoration: InputDecoration(
                            hintText: 'Enter your interest here....',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height * 0.02,
                                horizontal: MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "What are your personal goals?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _personalController,
                          decoration: InputDecoration(
                            hintText: 'Enter your personal goals here....',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height * 0.02,
                                horizontal: MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: _submitForm,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
        selectedLabelStyle: TextStyle(color: Colors.black),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }
}
