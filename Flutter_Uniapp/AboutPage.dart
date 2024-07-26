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
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.themeMode,
          home: AboutPage(),
        );
      },
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('About', style: TextStyle(color: Colors.white)),
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
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the App',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'This app is designed to help users manage their tasks efficiently and effectively. It offers a simple and intuitive interface for tracking daily activities, setting reminders, and more.',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Developer',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Developed by DP APPTEAM, a passionate software developer with a focus on creating useful and engaging mobile applications. For more information, visit [dpappteam.com] or contact [mailto:dpappteam@gmail.com].',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Features',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '1. Task Management\n2. Daily Reminders\n3. Simple and Intuitive Interface\n4. Customizable Themes\n5. Data Backup and Sync',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'For support or feedback, please contact us at mailto:support@dpappteam.com or call +1-234-567-890.',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                        backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      ),
                      child: Text('Back'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
