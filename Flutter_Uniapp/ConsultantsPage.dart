import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

      return consultantsData.map((json) => Consultant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load consultants');
    }
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
            return const Center(child: CircularProgressIndicator());
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(consultant.email),
                        Text(consultant.phone),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
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
                );
              },
            );
          }
        },
      ),
    );
  }
}

