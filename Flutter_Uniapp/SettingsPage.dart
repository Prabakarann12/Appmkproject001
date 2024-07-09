import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SignInPage.dart';

class Settingspage extends StatefulWidget {

  @override
  _SettingspageState createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  Color _backgroundColor = Colors.white;

  // Switch states
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _appNotifications = true;
  bool _appLock = true;
  bool _appDarkMode = false;

  Color _getTextColor() {
    return _backgroundColor == Colors.white ? Colors.black : Colors.white;
  }

  Widget _buildAnimatedColorChangeTile(BuildContext context) {
    return SettingsTile(
      icon: Icons.color_lens, // Or any icon you prefer
      title: 'Toggle Background Color',
      subtitle: 'Tap to toggle background color',
      textColor: _getTextColor(),
      iconColor: _getTextColor(),
      onTap: () {
        setState(() {
          _backgroundColor = _backgroundColor == Colors.white ? Colors.black : Colors.white;
        });
      },
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: TextStyle(color: _getTextColor())),
          content: Text('Are you sure you want to logout?', style: TextStyle(color: _getTextColor())),
          backgroundColor: _backgroundColor,
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: _getTextColor())),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  SignInPage()),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: _backgroundColor,
      body: ListView(
        children: [
          SettingsSection(
            title: 'Account Settings',
            tiles: [
              SettingsTile(
                icon: Icons.person,
                title: 'Profile Information',
                subtitle: 'View and edit your profile details',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.lock,
                title: 'Password Change',
                subtitle: 'Change your account password',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.security,
                title: 'Two-Factor Authentication',
                subtitle: 'Enable two-step verification',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
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
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                isSwitch: true,
                switchValue: _pushNotifications,
                onSwitchChanged: (bool value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              SettingsTile(
                icon: Icons.email,
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                isSwitch: true,
                switchValue: _emailNotifications,
                onSwitchChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              SettingsTile(
                icon: Icons.notifications_active,
                title: 'App Notifications',
                subtitle: 'Manage notifications from the app',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                isSwitch: true,
                switchValue: _appNotifications,
                onSwitchChanged: (bool value) {
                  setState(() {
                    _appNotifications = value;
                  });
                },
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
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                isSwitch: true,
                switchValue: _appLock,
                onSwitchChanged: (bool value) {
                  setState(() {
                    _appLock = value;
                  });
                },
              ),
              SettingsTile(
                icon: Icons.login,
                title: 'Login Alerts',
                subtitle: 'Receive alerts on login activities',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.question_answer,
                title: 'Security Questions',
                subtitle: 'Set security questions for account recovery',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Privacy',
            tiles: [
              SettingsTile(
                icon: Icons.shield,
                title: 'Data Sharing Preferences',
                subtitle: 'Set preferences for data sharing',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.visibility,
                title: 'Activity Status',
                subtitle: 'View your activity status',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.location_on,
                title: 'Location Settings',
                subtitle: 'Manage your location preferences',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Support',
            tiles: [
              SettingsTile(
                icon: Icons.help_center,
                title: 'Help Center',
                subtitle: 'Access help and support resources',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.bug_report,
                title: 'Report a Problem',
                subtitle: 'Report issues or bugs',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
              SettingsTile(
                icon: Icons.feedback,
                title: 'Feedback',
                subtitle: 'Give feedback on your app experience',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  // Add navigation or logic here
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Appearance',
            tiles: [
              SettingsTile(
                icon: Icons.color_lens,
                title: 'Toggle Background Color',
                subtitle: 'Tap to toggle background color',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                onTap: () {
                  setState(() {
                    _backgroundColor =
                    _backgroundColor == Colors.white ? Colors.black : Colors.white;
                  });
                },
              ),
              SettingsTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Enable dark mode',
                textColor: _getTextColor(),
                iconColor: _getTextColor(),
                isSwitch: true,
                switchValue: _appDarkMode,
                onSwitchChanged: (bool value) {
                  setState(() {
                    _appDarkMode = value;
                    // Toggle background color if dark mode is enabled
                    if (_appDarkMode) {
                      _backgroundColor = Colors.black; // Example background color for dark mode
                    } else {
                      _backgroundColor = Colors.white; // Example background color for light mode
                    }
                  });
                },
              ),
            ],
          ),
          SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: '',
            textColor: _getTextColor(),
            iconColor: _getTextColor(),
            onTap: () {
              showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const SettingsSection({
    required this.title,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        Column(children: tiles),
        const Divider(),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final Color textColor;
  final Color iconColor;

  const SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.7))),
      trailing: isSwitch
          ? Switch(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeColor: Colors.teal,
      )
          : null,
      onTap: onTap,
    );
  }
}