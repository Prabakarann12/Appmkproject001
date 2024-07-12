import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'Chatpage.dart';

class Consultant {
  final String name;
  final String email;
  final String imagePath;
  final String phone;

  Consultant({
    required this.name,
    required this.email,
    required this.imagePath,
    required this.phone,
  });

  factory Consultant.fromJson(Map<String, dynamic> json) {
    return Consultant(
      name: json['Concultants_name'],
      email: json['Concultants_email'],
      imagePath: json['Concultants_imagepath'],
      phone: json['Consultant_phone'],
    );
  }
}

class ConsultantsPage extends StatefulWidget {
  ConsultantsPage({Key? key}) : super(key: key);

  @override
  _ConsultantsPageState createState() => _ConsultantsPageState();
}

class _ConsultantsPageState extends State<ConsultantsPage> {
  late Future<List<Consultant>> futureConsultants;

  @override
  void initState() {
    super.initState();
    futureConsultants = fetchConsultants();
  }

  Future<List<Consultant>> fetchConsultants() async {
    final response = await http.get(Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/consultantshdata.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> consultantsData = jsonData['data'];

      List<Consultant> consultants = consultantsData.map((json) => Consultant.fromJson(json)).toList();
      consultants.sort((a, b) => a.name.compareTo(b.name)); // Sorting in alphabetical order
      return consultants;
    } else {
      throw Exception('Failed to load consultants');
    }
  }

  void _showOptions(BuildContext context, Consultant consultant) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.chat),
                iconColor: Colors.black,
                title: const Text('Chat', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        consultantName: consultant.name,
                        consultantImage: 'https://syfer001testing.000webhostapp.com/cloneapi/${consultant.imagePath}',
                        consultantPhoneNumber: consultant.phone,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                iconColor: Colors.black,
                title: const Text('Email', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: consultant.email,
                  );
                  launch(emailLaunchUri.toString());
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                iconColor: Colors.black,
                title: const Text('Call', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: consultant.phone,
                  );
                  launch(phoneLaunchUri.toString());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultants'),
      ),
      body: FutureBuilder<List<Consultant>>(
        future: futureConsultants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No consultants found'));
          } else {
            final consultants = snapshot.data!;
            return ListView.builder(
              itemCount: consultants.length,
              itemBuilder: (context, index) {
                final consultant = consultants[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.network(
                      'https://syfer001testing.000webhostapp.com/cloneapi/${consultant.imagePath}',
                      width: 50,

                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(consultant.name),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => _showOptions(context, consultant),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
