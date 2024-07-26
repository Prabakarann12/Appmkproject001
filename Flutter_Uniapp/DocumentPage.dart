import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'ThemeNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: DocumentPage(userId: 1),
    ),
  );
}

class DocumentPage extends StatefulWidget {
  final int userId;
  const DocumentPage({super.key, required this.userId});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  get userIdProfile => userIdProfile;
  double _uploadProgress = 0.0;
  List<String?> _selectedFiles = List.filled(4, null); // List to store file names for 3 sections
  bool _fileUploaded = false;
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  bool _aadhaarSubmitted = false;
  bool _passportSubmitted = false;

  Future<void> _pickDocument(int index) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final platformFile = result.files.first;
        final file = File(platformFile.path!);
        setState(() {
          _selectedFiles[index] = platformFile.name;
          _fileUploaded = false;
        });
        await _uploadFile(file, index);
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

  Future<void> _submit() async {
    bool allSectionsFilled = true;

    for (int i = 0; i < _selectedFiles.length; i++) {
      if (_selectedFiles[i] == null) {
        allSectionsFilled = false;
        break;
      }
    }

    if (allSectionsFilled) {
      // Submit all files
      try {
        final uri = Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Uni_docinsert.php');
        final request = http.MultipartRequest('POST', uri)
          ..fields['user_id'] = widget.userId.toString()
          ..fields['aadhaar'] = _aadhaarController.text
          ..fields['passport'] = _passportController.text;

        for (int i = 0; i < _selectedFiles.length; i++) {
          final selectedFile = _selectedFiles[i];
          if (selectedFile != null) {
            final fileField = ['tenth_marksheet', 'twelfth_marksheet', 'ug_certificate', 'medical_certificate'][i];
            request.files.add(await http.MultipartFile.fromPath(fileField, selectedFile));
          }
        }

        final response = await request.send();
        if (response.statusCode == 200) {
          print('Files and data submitted successfully');
          setState(() {
            _fileUploaded = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Files and data submitted successfully')),
          );
        } else {
          print('Failed to submit files and data');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit files and data')),
          );
        }
      } catch (e) {
        print('Error submitting files and data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting files and data: $e')),
        );
      }
    } else {
      print('Not all sections have files selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select files for all sections')),
      );
    }
  }

  Future<void> _uploadFile(File file, int index) async {
    try {
      final uri = Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Uni_docinsert.php');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.path.split('/').last))
        ..fields['id'] = Uuid().v4()
        ..fields['aadhaar'] = _aadhaarController.text
        ..fields['passport'] = _passportController.text;

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          backgroundColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text(
              "Document Upload",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DocumentUploadSection(
                    title: "10th Marksheet",
                    pickDocument: () => _pickDocument(0),
                    selectedFile: _selectedFiles[0],
                  ),
                  SizedBox(height: 10),
                  DocumentUploadSection(
                    title: "12th Marksheet",
                    pickDocument: () => _pickDocument(1),
                    selectedFile: _selectedFiles[1],
                  ),
                  SizedBox(height: 10),
                  DocumentUploadSection(
                    title: "Any UG Certificate",
                    pickDocument: () => _pickDocument(2),
                    selectedFile: _selectedFiles[2],
                  ),
                  SizedBox(height: 10),
                  DocumentUploadSection(
                    title: "Medical Certificate",
                    pickDocument: () => _pickDocument(3),
                    selectedFile: _selectedFiles[3],
                  ),

                  SizedBox(height: 10),
                  AadhaarInputSection(
                    aadhaarController: _aadhaarController,
                    aadhaarSubmitted: _aadhaarSubmitted,
                  ),
                  SizedBox(height: 10),
                  PassportInputSection(
                    passportController: _passportController,
                    passportSubmitted: _passportSubmitted,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      'Submit All',
                      style: TextStyle(color:themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DocumentUploadSection extends StatelessWidget {
  final String title;
  final Function() pickDocument;
  final String? selectedFile;

  DocumentUploadSection({
    required this.title,
    required this.pickDocument,
    required this.selectedFile,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child)
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
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
                      onPressed: pickDocument,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pick Document',
                            style: TextStyle(color: themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,),
                          ),
                          if (selectedFile != null)
                            Padding(
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
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected file: $selectedFile',
                          style: TextStyle(fontSize: 16,color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AadhaarInputSection extends StatelessWidget {
  final TextEditingController aadhaarController;
  final bool aadhaarSubmitted;

  AadhaarInputSection({
    required this.aadhaarController,
    required this.aadhaarSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child)
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aadhaar Input",
              style: TextStyle(
                color: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Card(
              color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: aadhaarController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hoverColor: themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        labelText: 'Enter Aadhaar Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PassportInputSection extends StatelessWidget {
  final TextEditingController passportController;
  final bool passportSubmitted;

  PassportInputSection({
    required this.passportController,
    required this.passportSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child)
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Passport Input",
              style: TextStyle(
                color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Card(
              color:  themeNotifier.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: passportController,
                      decoration: InputDecoration(
                        hoverColor:  themeNotifier.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        labelText: 'Enter Passport Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
