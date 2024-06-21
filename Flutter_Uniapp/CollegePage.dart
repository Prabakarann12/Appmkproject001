import 'package:flutter/material.dart';


class CollegePage extends StatelessWidget {
  const CollegePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = [
      'assets/mit.jpeg',
      'assets/icl.jpg',
      'assets/oxford-university.jpg',
      'assets/hu.jpg',
      'assets/uoc.jpeg',
      'assets/su.jpeg',
      'assets/eth.jpg',
      'assets/nus.jpg',
      'assets/ucl.jpg',
      'assets/ciot.jpeg',
    ];

    List<String> titles = [
      'Massachusetts Institute of Technology (MIT) ',
      'Imperial College London ',
      'University of Oxford ',
      'Harvard University ',
      'University of Cambridge',
      'Stanford University',
      'ETH Zurich (Swiss Federal Institute of Technology)',
      'National University of Singapore (NUS)',
      'UCL (University College London)',
      'California Institute of Technology (Caltech)',

    ];

    List<String> subtitles = [
      'United States ',
      'United Kingdom ',
      'United Kingdom ',
      'United States',
      'United Kingdom',
      'United States',
      'Switzerland  ',
      'Singapore ',
      'United Kingdom',
      'United States ',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('College',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,

      ),
      body: ListView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Image.asset(
                imagePaths[index],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(titles[index]),
              subtitle: Text(subtitles[index]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle card tap
              },
            ),
          );
        },
      ),
    );
  }
}