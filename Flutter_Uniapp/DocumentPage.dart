import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List<double> _uploadProgress = List.filled(7, 0.0); // List to store upload progress for 7 sections
  List<String?> _selectedFiles = List.filled(7, null); // List to store file names for 7 sections
  bool _fileUploaded = false;
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  bool _aadhaarSubmitted = false;
  bool _passportSubmitted = false;
  String? _selectedCategory; // Variable to track user selection (UG or PG)

  Future<void> _pickDocument(int index) async {
    // Show documents based on the selected category (UG or PG)
    switch (_selectedCategory) {
      case 'UG':
        _showUGDocuments(index);
        break;
      case 'PG':
        _showPGDocuments(index);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select UG or PG first')),
        );
    }
  }

  // Show UG documents
  void _showUGDocuments(int index) {
    setState(() {
      _selectedFiles = List.filled(2, null); // Only 10th and 12th marksheet for UG
    });
    _pickFile(index);
  }

  // Show PG documents
  void _showPGDocuments(int index) {
    setState(() {
      _selectedFiles = List.filled(3, null); // Include UG + PG documents
    });
    _pickFile(index);
  }

  // Method to actually pick the file
  Future<void> _pickFile(int index) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final platformFile = result.files.first;
        final file = File(platformFile.path!);
        setState(() {
          _selectedFiles[index] = platformFile.path;
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
      for (int i = 0; i < _selectedFiles.length; i++) {
        final selectedFile = _selectedFiles[i];
        if (selectedFile != null) {
          try {
            final uri = Uri.parse('https://syfer001testing.000webhostapp.com/cloneapi/Uni_docinsert.php');
            final request = http.MultipartRequest('POST', uri)
              ..files.add(await http.MultipartFile.fromPath('file', selectedFile))
              ..fields['id'] = Uuid().v4()
              ..fields['aadhaar'] = _aadhaarController.text
              ..fields['passport'] = _passportController.text;

            final response = await request.send();
            if (response.statusCode == 200) {
              print('File and data submitted successfully');
              setState(() {
                _fileUploaded = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('File and data submitted successfully')),
              );
            } else {
              print('Failed to submit file and data');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to submit file and data')),
              );
            }
          } catch (e) {
            print('Error submitting file and data: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error submitting file and data: $e')),
            );
          }
        }
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
      final uri = Uri.parse('');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.path.split('/').last))
        ..fields['id'] = Uuid().v4()
        ..fields['aadhaar'] = _aadhaarController.text
        ..fields['passport'] = _passportController.text;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      streamedResponse.stream.listen(
            (value) {
          setState(() {
            _uploadProgress[index] += value.length / streamedResponse.contentLength!;
          });
        },
        onDone: () async {
          if (response.statusCode == 200) {
            final responseData = response.body;
            print('File uploaded successfully: $responseData');
            setState(() {
              _uploadProgress[index] = 1.0;
              _fileUploaded = true;
            });
          } else {
            print('File upload failed with status: ${response.statusCode}');
            print('Response body: ${response.body}');
            setState(() {
              _uploadProgress[index] = 0.0;
              _fileUploaded = false;
            });
          }
        },
        onError: (e) {
          print('Error uploading file: $e');
          setState(() {
            _uploadProgress[index] = 0.0;
            _fileUploaded = false;
          });
        },
      );
    } catch (e) {
      print('Error uploading file: $e');
      setState(() {
        _uploadProgress[index] = 0.0;
        _fileUploaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Document Verification",
          style: const TextStyle(color: Colors.white),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _selectedCategory,
                hint: Text('Select Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    // Reset selected files when category changes
                    _selectedFiles = List.filled(7, null);
                  });
                },
                items: [
                  DropdownMenuItem(child: Text('UG'), value: 'UG'),
                  DropdownMenuItem(child: Text('PG'), value: 'PG'),
                ],
              ),
              SizedBox(height: 20),
              if (_selectedCategory == 'UG' || _selectedCategory == 'PG')
                DocumentUploadSection(
                  title: "10th Marksheet",
                  pickDocument: () => _pickDocument(0),
                  selectedFile: _selectedFiles[0],
                  progress: _uploadProgress[0],
                ),
              if (_selectedCategory == 'UG' || _selectedCategory == 'PG')
                SizedBox(height: 10),
              if (_selectedCategory == 'UG' || _selectedCategory == 'PG')
                DocumentUploadSection(
                  title: "12th Marksheet",
                  pickDocument: () => _pickDocument(1),
                  selectedFile: _selectedFiles[1],
                  progress: _uploadProgress[1],
                ),
              if (_selectedCategory == 'PG')
                SizedBox(height: 10),
              if (_selectedCategory == 'PG')
                DocumentUploadSection(
                  title: "Any UG Certificate",
                  pickDocument: () => _pickDocument(2),
                  selectedFile: _selectedFiles[2],
                  progress: _uploadProgress[2],
                ),
              SizedBox(height: 10),
              DocumentUploadSection(
                title: "Medical Certificate",
                pickDocument: () => _pickDocument(3),
                selectedFile: _selectedFiles[3],
                progress: _uploadProgress[3],
              ),
              SizedBox(height: 10),
              DocumentUploadSection(
                title: "Blood Certificate",
                pickDocument: () => _pickDocument(4),
                selectedFile: _selectedFiles[4],
                progress: _uploadProgress[4],
              ),
              SizedBox(height: 10),
              DocumentUploadSection(
                title: "Extracurricular Activities Certificate",
                pickDocument: () => _pickDocument(5),
                selectedFile: _selectedFiles[5],
                progress: _uploadProgress[5],
              ),
              SizedBox(height: 10),
              DocumentUploadSection(
                title: "Signature",
                pickDocument: () => _pickDocument(6),
                selectedFile: _selectedFiles[6],
                progress: _uploadProgress[6],
              ),
              SizedBox(height: 20),
              AadhaarInputSection(
                controller: _aadhaarController,
                onChanged: () {
                  setState(() {
                    _aadhaarSubmitted = false;
                  });
                },
              ),
              SizedBox(height: 10),
              PassportInputSection(
                controller: _passportController,
                onChanged: () {
                  setState(() {
                    _passportSubmitted = false;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentUploadSection extends StatelessWidget {
  final String title;
  final VoidCallback pickDocument;
  final String? selectedFile;
  final double progress;

  const DocumentUploadSection({
    Key? key,
    required this.title,
    required this.pickDocument,
    required this.selectedFile,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: pickDocument,
              child: Text('Pick Document'),
            ),
            if (selectedFile != null)
              Container(
                width: 150,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                ),
              ),
            if (selectedFile != null) SizedBox(width: 10),
            if (selectedFile != null)
              TextButton(
                onPressed: () {},
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class AadhaarInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const AadhaarInputSection({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aadhaar Number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            hintText: 'Enter Aadhaar Number',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class PassportInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const PassportInputSection({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passport Number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            hintText: 'Enter Passport Number',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
