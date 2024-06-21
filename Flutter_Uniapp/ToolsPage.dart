import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MyCardData {
  final String title;
  final String content;
  final String imageUrl;

  MyCardData(this.title, this.content, this.imageUrl);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToolsPage(),
    );
  }
}

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0; // Track the selected index
  int _selectedIndex1 = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex1 = index;
    });
  }

  List<MyCardData> cardData = [
    MyCardData('All', 'Content for Card 1', 'assets/image1.png'),
    MyCardData('Visa', 'Content for Card 2', 'assets/image2.png'),
    MyCardData('PDF Tools', 'Upload', 'assets/image1.png'),
    MyCardData('IMM', 'International Money Market', 'assets/imm.png'),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildCardContent(int index) {
    switch (index) {
      case 0:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemCount: 3, // Assuming labels and images have the same length
            itemBuilder: (context, gridIndex) {
              final labels = ['Visa', 'PDF Tools', 'IMM'];
              final images = [
                'https://syfer001testing.000webhostapp.com/cloneapi/savefile/visa.png',
                'https://syfer001testing.000webhostapp.com/cloneapi/savefile/pdf1.jpg',
                'https://syfer001testing.000webhostapp.com/cloneapi/savefile/imm1.jpg',
              ];
              return GridItem(
                label: labels[gridIndex],
                image: images[gridIndex],
                onTap: () {
                  setState(() {
                    _selectedIndex = gridIndex + 1;
                  });
                },
              );
            },
          ),
        );
      case 1:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  children: List.generate(4, (gridIndex) {
                    final labels = [
                      'GIC Account request',
                      'Template',
                      'English tests',
                      'Consultant call'
                    ];
                    final images = [
                      'https://syfer001testing.000webhostapp.com/cloneapi/savefile/doller.jpg',
                      'https://syfer001testing.000webhostapp.com/cloneapi/savefile/temp.webp',
                      'https://syfer001testing.000webhostapp.com/cloneapi/savefile/classUni.jpg',
                      'https://syfer001testing.000webhostapp.com/cloneapi/savefile/consultant.jpg',
                    ];

                    return Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: images[gridIndex].startsWith('http')
                                ? Image.network(
                              images[gridIndex],
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              images[gridIndex],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          labels[gridIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      case 2:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(cardData[index].imageUrl, height: 100),
              SizedBox(height: 20),
              Text(
                cardData[index].content,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Do something for Card 3
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.black87,
                ),
                child: Text('click here'),
              ),
            ],
          ),
        );
      case 3:
        return Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(cardData[index].imageUrl, height: 100),
              SizedBox(height: 20),
              Text(
                cardData[index].content,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Do something for Card 4
                },
                child: Text('Button for Card 4'),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Explore study abroad tools",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_copy_outlined, color: Colors.black),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cardData[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: index == _selectedIndex
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 30,
                              color: index == _selectedIndex
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: index == _selectedIndex,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: buildCardContent(index),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String label;
  final String image;
  final VoidCallback onTap;

  const GridItem({
    Key? key,
    required this.label,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: image.startsWith('http')
                  ? Image.network(
                image,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
