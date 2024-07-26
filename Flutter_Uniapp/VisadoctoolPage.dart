import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'ThemeNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Visadoctoolpage(), // Example userId
    );
  }
}
Future<void> _requestPermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission is granted
  } else {
    // Permission denied, handle it accordingly
  }
}
class Visadoctoolpage extends StatefulWidget {
  @override
  _Visadoctoolpage createState() => _Visadoctoolpage();
}

class _Visadoctoolpage extends State<Visadoctoolpage> {
  double _uploadProgress = 0.0;
  double _uploadProgress1 = 0.0;
  int _selectedIndex = 0;
  String? _selectedFile;
  String? _visaDocumentUrl;
  bool _isChecked = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _fileUploaded = false;

  Widget _buildSelectedFileCard() {
    if (_selectedFile == null) {
      return Container();
    }

    return Card(
      child: ListTile(
        title: Text('Selected File:'),
        subtitle: Text(_selectedFile!),
      ),
    );
  }

  Widget _buildVisaDocumentLinkCard() {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Card(
          color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Link Visa Document",
                  style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _visaDocumentUrl = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hoverColor: Colors.black,
                    labelText: 'Enter URL for study plan',
                    border: OutlineInputBorder(

                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _linkVisaDocument,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Accepted File type: PDF, JPG, or provide a URL",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: _uploadProgress1,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final platformFile = result.files.first;
        final file = File(platformFile.path!);
        setState(() {
          _selectedFile = platformFile.name;
          _fileUploaded = false;
        });
        await _uploadFile(file);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File picked: ${platformFile.name}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file was picked')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _linkVisaDocument() async {
    if (_visaDocumentUrl != null) {
      // Handle linking the Visa document via URL
      print('Visa Document linked: $_visaDocumentUrl');
    } else {
      print('No URL provided');
    }
  }

  Future<void> _submit() async {
    if (_selectedFile != null) {
      try {
        final uri = Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/doumentupload.php');
        final request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath('file', _selectedFile!));

        final response = await request.send();
        if (response.statusCode == 200) {
          print('File submitted successfully');
          setState(() {
            _fileUploaded = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File submitted successfully')),
          );
        } else {
          print('Failed to submit file');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit file')),
          );
        }
      } catch (e) { }
    } else {
      print('No file selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _uploadFile(File file) async {
    try {
      final uri = Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/doumentupload.php');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.path.split('/').last))
        ..fields['id'] = Uuid().v4();

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = response.body;
        print('File uploaded successfully: $responseData');
        setState(() {
          _uploadProgress = 1.0;
          _fileUploaded = true;
        });
      } else {
        print('File upload failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _uploadProgress = 0.0;
          _fileUploaded = false;
        });
      }
    } catch (e) {
      print('Error uploading file: $e');
      setState(() {
        _uploadProgress = 0.0;
        _fileUploaded = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child)
    {
      return Scaffold(
        backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Visa document",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Notification button pressed
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
                // Profile button pressed
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Upload Document",
                  style: TextStyle(
                    color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
                Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: _pickDocument,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text(
                                'Pick Document',
                                style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,),
                              ),
                              if (_fileUploaded)
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_selectedFile != null)
                          Text(
                            'Picked file: $_selectedFile',
                            style:  TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                          ),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        if (_selectedFile != null)
                          ElevatedButton(
                            onPressed: _submit,
                            child:  Text(
                              'Submit',
                              style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (_selectedFile == null)
                          const Text(
                            'Please pick a file before submitting.',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildVisaDocumentLinkCard(),
                SizedBox(height: 10,),
                Text(
                  "Feedback and Recommendations",
                  style: TextStyle(
                    color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
                Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Consultants name",
                          style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,fontSize: 15),
                        ),
                        SizedBox(height: 0,),
                        Text("Timestamp",
                          style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, fontSize: 10),),
                        const SizedBox(height: 10),
                        Text(
                          "Detailed feedback on the document or study plan.",
                          style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,fontSize: 15),
                        ),
                        SizedBox(height: 10,),
                        Text("Replay marke as Resolved",
                          style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "Suggestions for revition",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
                Card(
                  color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              activeColor: Colors.cyan,
                            ),
                            Text('Suggestions 1',style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black, ),),
                          ],
                        ),
                        SizedBox(height: 2,),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked1,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked1 = value!;
                                });
                              },
                              activeColor: Colors.cyan,
                            ),
                            Text('Suggestions 2',style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                          ],
                        ),
                        SizedBox(height: 2,),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked2,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked2 = value!;
                                });
                              },
                              activeColor: Colors.cyan,
                            ),
                            Text('Suggestions 3',style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_upload_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.join_inner_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      );
    },
    );
  }
}
