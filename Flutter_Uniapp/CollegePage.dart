import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ThemeNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: CollegePage(),
    ),
  );
}

class CollegePage extends StatelessWidget {
  const CollegePage({super.key});

  Future<List<dynamic>> fetchUniversities() async {
    final response = await http.get(
      Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Alphaapi.php?requestby=universitiesdata'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child)
      {
        return Scaffold(
          appBar: AppBar(
            title: const Text('College', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black87,
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
          backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          body: FutureBuilder<List<dynamic>>(
            future: fetchUniversities(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final university = snapshot.data![index];
                    return Card(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: Image.network(
                          'https://syfer001testing.000webhostapp.com/cloneapi/${university['image_path']}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(university['universities_title'],style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, ),),
                        subtitle: Text(university['universities_subtitle'],style: TextStyle(color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                        trailing:  Icon(Icons.arrow_forward,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                        onTap: () {
                          final url = university['university_website']; // Ensure your JSON data contains 'university_website'
                          _launchURL(url);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
