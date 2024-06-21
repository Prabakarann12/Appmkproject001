import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Chatpage.dart';

class ConsultantsPage extends StatelessWidget {
  ConsultantsPage({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchConsultants() async {
    final response = await http.get(
      Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/consultantshdata.php'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Consultants'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchConsultants(),
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
                    leading: Image.asset(
                      'assets/${consultant['Concultants_Image']}',
                      width: 50,
                      height: 50,

                      fit: BoxFit.cover,

                    ),
                    title: Text(consultant['Concultants_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('mailto:${consultant['Concultants_email']}'),
                        Text(consultant['Consultant_phone']),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            consultantName: consultant['Concultants_name'],
                            consultantImage: 'assets/${consultant['Concultants_Image']}',
                            consultantPhoneNumber: consultant['Consultant_phone'],
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
