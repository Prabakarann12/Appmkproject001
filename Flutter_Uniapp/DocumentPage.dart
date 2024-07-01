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

  Future<void> _pickDocument(int index) async {
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
            final uri = Uri.parse('');
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
              DocumentUploadSection(
                title: "10th Marksheet",
                pickDocument: () => _pickDocument(0),
                selectedFile: _selectedFiles[0],
                progress: _uploadProgress[0],
              ),
              SizedBox(height: 10),
              DocumentUploadSection(
                title: "12th Marksheet",
                pickDocument: () => _pickDocument(1),
                selectedFile: _selectedFiles[1],
                progress: _uploadProgress[1],
              ),
              SizedBox(height: 10),
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
                title: "Income Certificate",
                pickDocument: () => _pickDocument(6),
                selectedFile: _selectedFiles[6],
                progress: _uploadProgress[6],
              ),
              SizedBox(height: 10),
              AadhaarInputSection(
                aadhaarController: _aadhaarController,
                aadhaarSubmitted: _aadhaarSubmitted,
                onSubmitted: (value) {
                  setState(() {
                    _aadhaarSubmitted = true;
                  });
                },
              ),
              SizedBox(height: 10),
              PassportInputSection(
                passportController: _passportController,
                passportSubmitted: _passportSubmitted,
                onSubmitted: (value) {
                  setState(() {
                    _passportSubmitted = true;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              if (_fileUploaded)
                Center(
                  child: Text(
                    'Files and data uploaded successfully!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

  DocumentUploadSection({
    required this.title,
    required this.pickDocument,
    required this.selectedFile,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: pickDocument,
          child: Text(
            'Pick Document',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
        if (selectedFile != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected file: ${selectedFile!.split('/').last}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
              ),
              SizedBox(height: 10),
            ],
          ),
      ],
    );
  }
}
class AadhaarInputSection extends StatelessWidget {
  final TextEditingController aadhaarController;
  final bool aadhaarSubmitted;
  final Function(String) onSubmitted;

  AadhaarInputSection({
    required this.aadhaarController,
    required this.aadhaarSubmitted,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aadhaar Number',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: aadhaarController,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Aadhaar Number',
            errorText: aadhaarSubmitted && aadhaarController.text.isEmpty ? 'Aadhaar Number is required' : null,
          ),
        ),
      ],
    );
  }
}

class PassportInputSection extends StatelessWidget {
  final TextEditingController passportController;
  final bool passportSubmitted;
  final Function(String) onSubmitted;

  PassportInputSection({
    required this.passportController,
    required this.passportSubmitted,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passport Number',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: passportController,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Passport Number',
            errorText: passportSubmitted && passportController.text.isEmpty ? 'Passport Number is required' : null,
          ),
        ),
      ],
    );
  }
}
