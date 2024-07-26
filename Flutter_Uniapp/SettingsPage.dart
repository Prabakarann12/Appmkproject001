import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniflutterprot01/Help&supportPage.dart';
import 'ProfileInformationPage.dart';
import 'SecurityQuestionsPage.dart';
import 'SignInPage.dart';
import 'ThemeNotifier.dart';
import 'forgotpwPage.dart';
import 'AboutPage.dart';

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
    primaryColor: Colors.blue,
    hintColor: Colors.amber,
  );
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey,
    hintColor: Colors.blueAccent,
    // Add other properties as needed
  );
  @override
  Widget build(BuildContext context) {
    final int userId = ModalRoute.of(context)!.settings.arguments as int;
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
          home: SettingsPage(userId: 1,),
        );
      },
    );
  }
}

class SettingsPage extends StatefulWidget {
  final int userId;
  const SettingsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = false;
  bool _appLock = true;

  @override
  void initState() {
    super.initState();

  }
  void _loadNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? false; // Default to off
    });
  }
  void _updateNotificationSettings(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);

    if (value) {

    } else {

    }
  }
  void showLogoutConfirmationDialog(BuildContext context, ThemeNotifier themeNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
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
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          body: ListView(
            children: [
              SettingsSection(
                title: 'Account Settings',
                tiles: [
                  SettingsTile(
                    icon: Icons.person,
                    title: 'Profile Information',
                    subtitle: 'View and edit your profile details',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileInformationPage(userId: widget.userId)),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.lock,
                    title: 'Password Change',
                    subtitle: 'Change your account password',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Notifications',
                tiles: [
                  SettingsTile(
                    icon: Icons.notifications,
                    title: 'Push Notifications',
                    subtitle: 'Receive notifications instantly',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    isSwitch: true,
                    switchValue: _pushNotifications,
                    onSwitchChanged: (bool value) {
                      setState(() {
                        _pushNotifications = value;
                        _updateNotificationSettings(value);
                      });
                    },
                    activeColor: Colors.teal,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey,
                  ),
                ],
              ),
              SettingsSection(
                title: 'Security',
                tiles: [
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: 'App Lock',
                    subtitle: 'Enable app lock for added security',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    isSwitch: true,
                    switchValue: _appLock,
                    onSwitchChanged: (bool value) {
                      setState(() {
                        _appLock = value;
                      });
                    },
                  ),
                  SettingsTile(
                    icon: Icons.question_answer,
                    title: 'Security Questions',
                    subtitle: 'Set security questions for account recovery',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors
                        .white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors
                        .white : Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecurityQuestionsPage()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.brightness_6,
                    title: 'Dark Mode',
                    subtitle: 'Toggle dark/light theme',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    trailing: Switch(
                      value: themeNotifier.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeNotifier.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeColor: Colors.teal,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),

                ],
              ),
              SettingsSection(
                title: 'Miscellaneous',
                tiles: [
                  SettingsTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help and support',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpSupportPage()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.info,
                    title: 'About Us',
                    subtitle: 'Learn more about us',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    iconColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                      },
                  ),
                  SettingsTile(
                    icon: Icons.logout,
                    iconColor: Colors.black,
                    title: 'Logout',
                    textColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    subtitle: 'Sign out of your account?',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text('Sign out of your account?',style: TextStyle(fontSize: 20, color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),

                            actions: [
                              TextButton(
                                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dismiss the dialog
                                },
                              ),
                              TextButton(
                                child: Text('Logout', style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dismiss the dialog
                                  _logout(context); // Perform the logout action
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data from SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
}


class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  SettingsSection({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal
            ),
          ),
        ),
        ...tiles,
        Divider(height: 1),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color iconColor;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color activeColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;


  SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.iconColor,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    this.trailing,
    this.activeColor = Colors.teal,
    this.inactiveThumbColor = Colors.black,
    this.inactiveTrackColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(color: textColor)),
      trailing: isSwitch
          ? Switch(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeColor: Colors.teal,
        inactiveThumbColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        inactiveTrackColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white24 : Colors.black26,
      )
          : trailing,
      onTap: onTap,
    );
  }
}
