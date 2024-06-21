import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'SignInPage.dart';
import 'SearchPage.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double height = constraints.maxHeight;
            double width = constraints.maxWidth;

            return Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: width * 0.09, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Explore programs and connect globally",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: width * 0.04),
                      ),
                      Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: Container(
                          height: height * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/WelcomeHomePG.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        child: Text(
                          "Unistudy",
                          style: TextStyle(fontSize: width * 0.09, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02,),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // background color
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // text color
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: width * 0.30, vertical: height * 0.02), // padding
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: width * 0.04), // font size
                            ),
                          ),
                          child: Text('Login'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // background color
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // text color
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: width * 0.18, vertical: height * 0.02), // padding
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: width * 0.04), // font size
                            ),
                          ),
                          child: Text("Create an account"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
