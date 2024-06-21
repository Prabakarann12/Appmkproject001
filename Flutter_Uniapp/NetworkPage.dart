import 'package:flutter/material.dart';


class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = [
      'assets/a.png',
      'assets/b.png',
      'assets/c.png',
      'assets/d.png',
      'assets/e.png',
      'assets/f.png',
      'assets/g.png',
      'assets/h.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network',style: TextStyle(color: Colors.white),),
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
              title: Text('Network Item $index'),
              subtitle: Text('This is a description for item $index.'),
              trailing: Icon(Icons.arrow_forward),
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


