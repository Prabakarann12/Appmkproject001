import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:readmore/readmore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'MapPage.dart';

class PropertyDetailsPage2 extends StatefulWidget {
  final Map<String, dynamic> property;

  PropertyDetailsPage2({required this.property});

  @override
  _PropertyDetailsPage2State createState() => _PropertyDetailsPage2State();
}

class _PropertyDetailsPage2State extends State<PropertyDetailsPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _questionText = TextEditingController();
  bool _isSending = false;
  String _statusMessage = '';
  String? amenityLabel;
  late String seoRental; // Declare the variable to store SEO_rental
  late Map<DateTime, List> _events;
  List<DateTime> _selectedDates = [];
  List<DateTime> _unavailableDates = [];
  List<DateTime> _availableDates = [];
  DateTime _focusedDay = DateTime.now();
  late Set<DateTime> _bookedDates;

  @override
  void initState() {
    super.initState();
    seoRental = widget.property['SEO_rental']; // Store the value
    _fetchPropertyDetails(seoRental);
    _focusedDay = DateTime.now();
    _bookedDates = {
      DateTime(2024, 8, 10),
      DateTime(2024, 8, 15),
      DateTime(2024, 8, 16),
      DateTime(2024, 8, 17),
    };
  }

  Future<void> _fetchPropertyDetails(String seoRental) async {
    final url = 'http://api-alpha.square1server.com/api/getrental1';
    final Map<String, String> queryParams = {
      "SEO_rental": seoRental, // Use the variable here
    };
    final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> amenityLabels = data['search_resultsquery'][0]['amenity_label'];
        print('Amenity Labels: $amenityLabels');
        final String amenitiesString = amenityLabels.join(', ');
        setState(() {
          amenityLabel = amenitiesString;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        _showDialog(context, "Error", "Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred: $e');
      _showDialog(context, "Error", "An error occurred: $e");
    }
  }

  // Helper method to show a dialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _questionText.dispose();
    super.dispose();
  }
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;
      final questionText = _questionText.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitting form: $firstName $lastName, $email, $phone, $questionText')),
      );

      sendingMail(email, firstName, lastName, phone, questionText);
    }
  }

  Future<void> sendingMail(String recipientEmail, String firstName, String lastName, String phone, String questionText) async {
    try {
      setState(() {
        _isSending = true;
        _statusMessage = '';
      });

      var userEmail = 'prabakarann1298@gmail.com'; // Your email
      var password = ''; // Your email app password

      final smtpServer = gmail(userEmail, password);

      final message = Message()
        ..from = Address(userEmail, 'Coldwell')
        ..recipients.add(userEmail)
        ..subject = 'User Query'
        ..text = 'Hello,\n\n'
            'You have received a new query from the user. Here are the details:\n\n'
            'First Name: $firstName\n'
            'Last Name: $lastName\n'
            'Email: $recipientEmail\n'
            'Phone: $phone\n'
            'Question: $questionText\n\n'
            'Best regards,\n'
            'Cold well Team';

      await send(message, smtpServer);

      setState(() {
        _statusMessage = 'Email sent successfully';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to send email: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.property['propertyname'] ?? 'Property Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainApp()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                itemCount: widget.property['imageurl']?.length ?? 0,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  final imageUrl = widget.property['imageurl'][index];
                  return imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : Placeholder();
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  viewportFraction: 0.95,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.property['propertyname'] ?? 'Property Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.property['propertyheadline'] ?? 'Property Headline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Location: ${widget.property['city'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bed: ${widget.property['bedroom'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Bath: ${widget.property['bathroom'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Sleeps up to: ${widget.property['sleepupto'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'SEO Rental: ${widget.property['SEO_rental'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Pets: ${widget.property['pets'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              ReadMoreText(
                'Description: ${widget.property['propertydesc'] ?? 'N/A'}',
                trimLines: 3,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,
                trimCollapsedText: '...more',
                trimExpandedText: ' less',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Amenity:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6.0),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8.0, // Horizontal spacing between lines
                      runSpacing: 4.0, // Vertical spacing between lines
                      children: [
                        for (var i = 0; i < (amenityLabel?.split(', ') ?? []).length / 2; i++)
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                            child: Text(
                              (amenityLabel?.split(', ') ?? [])[i],
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3, // Limit to 3 lines
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0), // Space between the two columns
                  Expanded(
                    child: Wrap(
                      spacing: 8.0, // Horizontal spacing between lines
                      runSpacing: 4.0, // Vertical spacing between lines
                      children: [
                        for (var i = (amenityLabel?.split(', ') ?? []).length ~/ 2; i < (amenityLabel?.split(', ') ?? []).length; i++)
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                            child: Text(
                              (amenityLabel?.split(', ') ?? [])[i],
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3, // Limit to 3 lines
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Map showing the property location
              SizedBox(
                height: 400,
                child: MapSample(
                  location: LatLng(
                    double.parse(widget.property['latitude'] ?? '0.0'),
                    double.parse(widget.property['longitude'] ?? '0.0'),
                  ),
                  property: {
                    'imgPreview': widget.property['imgPreview'] ?? '',
                    'Address': widget.property['city'] ?? 'Unknown Address',
                    'Type': widget.property['propertytype'] ?? 'Unknown Type',
                  },
                ),
              ),
              SizedBox(height: 16),
              // Date Available Picker
              Text(
                'Select Dates:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime(2024),
                lastDay: DateTime(2026),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return _selectedDates.any((selectedDay) => isSameDay(day, selectedDay));
                },
                enabledDayPredicate: (day) {
                  return !(_unavailableDates.any((unavailableDay) => isSameDay(day, unavailableDay)) ||
                      _bookedDates.any((bookedDay) => isSameDay(day, bookedDay)) ||
                      day.isBefore(DateTime.now().subtract(Duration(days: 1))));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (_unavailableDates.any((unavailableDay) => isSameDay(selectedDay, unavailableDay)) ||
                      _bookedDates.any((bookedDay) => isSameDay(selectedDay, bookedDay))) {
                    return;
                  }

                  setState(() {
                    _focusedDay = focusedDay;

                    if (_selectedDates.any((selectedDay) => isSameDay(selectedDay, selectedDay))) {
                      _selectedDates.remove(selectedDay);
                    } else {
                      _selectedDates.add(selectedDay);
                    }
                  });
                },
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  disabledDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  disabledTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.white),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (_bookedDates.any((bookedDay) => isSameDay(day, bookedDay))) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (_unavailableDates.any((unavailableDay) => isSameDay(day, unavailableDay))) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (_availableDates.any((availableDay) => isSameDay(day, availableDay))) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              // Display selected dates
              Text(
                'Selected Dates:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                children: _selectedDates
                    .map((date) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Chip(
                    backgroundColor: Colors.green,
                    label: Text(
                      '${date.day}/${date.month}/${date.year}',
                    ),
                    labelStyle: TextStyle(color: Colors.white),

                  ),
                ))
                    .toList(),
              ),
              SizedBox(height: 10),
              SizedBox(
                child: Card(
                  color: Colors.grey[300], // Set the card color to gray
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the border radius for the card
                  ),
                  elevation: 4,

                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Add padding inside the card
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text('Request Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                          SizedBox(height: 10,),
                          Text(
                            widget.property['propertyheadline'] ?? 'Property Headline',
                            style: TextStyle(color: Colors.black , fontSize: 20, fontStyle:FontStyle.italic),textAlign: TextAlign.center),
                          SizedBox(height: 25),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(20), // Set border radius for the text field
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: Colors.black,
                              hoverColor: Colors.black,
                              focusColor: Colors.black,
                            ),
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16), // Add space between fields
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20), // Set border radius for the text field
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.black,
                                hoverColor: Colors.black,
                                focusColor: Colors.black
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16), // Add space between fields
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20), // Set border radius for the text field
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.black,
                                hoverColor: Colors.black,
                                focusColor: Colors.black
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16), // Add space between fields
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20), // Set border radius for the text field
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.black,
                                hoverColor: Colors.black,
                                focusColor: Colors.black
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16), // Add space between fields
                          TextFormField(
                            controller: _questionText,
                            decoration: InputDecoration(
                                labelText: 'include Any Questin and Answer Here',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20), // Set border radius for the text field
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.black,
                                hoverColor: Colors.black,
                                focusColor: Colors.black
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.indigo[900]),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
                            ),
                          )
                        ],
                      ),
                    ),
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
