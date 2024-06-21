import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  late Future<List<School>> futureSchools;

  @override
  void initState() {
    super.initState();
    futureSchools = fetchSchools();
  }

  Future<List<School>> fetchSchools() async {
    final response = await http.get(Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/School_listdata.php'));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      return parsed.map<School>((json) => School.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schools');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School', style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder<List<School>>(
        future: futureSchools,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No schools found'));
          } else {
            final schools = snapshot.data!;
            return ListView.builder(
              itemCount: schools.length,
              itemBuilder: (context, index) {
                final school = schools[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.network(
                      'https://syfer001testing.000webhostapp.com/cloneapi/${school.imagePath}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(school.title),
                    subtitle: Text(school.subtitle),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      launchWebsite(school.website);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class School {
  final String imagePath;
  final String title;
  final String subtitle;
  final String website;

  School({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.website,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      imagePath: json['School_image_path'],
      title: json['School_title'],
      subtitle: json['School_subtitle'],
      website: json['school_website'],
    );
  }
}
