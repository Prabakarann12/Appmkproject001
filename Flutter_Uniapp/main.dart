import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'SignInPage.dart';
import 'RegisterPage.dart';
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
  // Define the light theme
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.grey,
    hintColor: Colors.grey,
    // Add other properties as needed
  );

  // Define the dark theme
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey,
    hintColor: Colors.grey,
    // Add other properties as needed
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
          home:HomePage1(),
        );
      },
    );
  }
}

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}
class _HomePage1State extends State<HomePage1> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to show login buttons',
        options: AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _authenticated = authenticated;
      });
    } catch (e) {
      print(e);
    }
  }

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
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: height * 0.05),
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: width * 0.09, fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Explore programs and connect globally",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: width * 0.04),
                      ),
                    ],
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
                  Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text(
                        "Unistudy",
                        style: TextStyle(fontSize: width * 0.09, fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                      SizedBox(height: height * 0.02),
                      if (!_authenticated) ...[
                        SizedBox(height: 10),
                        Divider(color: Colors.black),
                        SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: _authenticate,
                          icon: Icon(Icons.fingerprint,color: Colors.black,),

                          label: Text("Authenticate", style: TextStyle(color: Colors.black),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Replace with your desired color
                          ),

                        ),

                        SizedBox(height: 20,)
                      ],
                      if (_authenticated) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height * 0.02),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=> SignInPage())
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
                                MaterialPageRoute(builder: (context)=>RegisterPage())
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
