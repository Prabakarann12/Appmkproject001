import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolPage extends StatelessWidget {
  const SchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = [
      'assets/mit.jpeg',
      'assets/icl.jpg',
      'assets/uoc.jpeg',
      'assets/hu.jpg',
      'assets/uoc.jpeg',
      'assets/su.jpeg',
      'assets/eth.jpg',
      'assets/nus.jpg',
      'assets/ucl.jpg',
      'assets/ciot.jpeg',
    ];

    List<String> titles = [
      'Massachusetts Institute of Technology (MIT)',
      'Imperial College London',
      'University of Oxford',
      'Harvard University',
      'University of Cambridge',
      'Stanford University',
      'ETH Zurich (Swiss Federal Institute of Technology)',
      'National University of Singapore (NUS)',
      'University College London (UCL)',
      'California Institute of Technology (Caltech)',
    ];

    List<String> subtitles = [
      '77 Massachusetts Ave, Cambridge, MA 02139, United States',
      'South Kensington, London SW7 2BU, United Kingdom',
      'Oxford OX1 2JD, United Kingdom',
      'Cambridge, MA 02138, United States',
      'The Old Schools, Trinity Ln, Cambridge CB2 1TN, United Kingdom',
      '450 Serra Mall, Stanford, CA 94305, United States',
      'Rämistrasse 101, 8092 Zürich, Switzerland',
      '21 Lower Kent Ridge Rd, Singapore 119077',
      'Gower St, London WC1E 6BT, United Kingdom',
      '1200 E California Blvd, Pasadena, CA 91125, United States',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('School',style: TextStyle(color: Colors.white),),
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
                launchWebsite(index);
              },
            ),
          );
        },
      ),
    );
  }

  void launchWebsite(int index) async {
    List<String> websites = [
      'https://web.mit.edu',
      'https://www.imperial.ac.uk',
      'https://www.ox.ac.uk',
      'https://www.harvard.edu',
      'https://www.cam.ac.uk',
      'https://www.stanford.edu',
      'https://ethz.ch',
      'https://www.nus.edu.sg',
      'https://www.ucl.ac.uk',
      'https://www.caltech.edu',
    ];

    String url = websites[index];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}