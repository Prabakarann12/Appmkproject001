import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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
  late String seoRental;
  late Map<DateTime, List> _events;
  List<DateTime> _selectedDates = [];
  List<DateTime> _unavailableDates = [];
  List<DateTime> _availableDates = [];
  DateTime _focusedDay = DateTime.now();
  Set<DateTime> _bookedDates = {};
  String availabilityLabel = '';
  String rentalRateLabel = '';
  List<Map<String, dynamic>> rentalRates = [];


  @override
  void initState() {
    super.initState();
    seoRental = widget.property['SEO_rental'];
    _fetchPropertyDetails(seoRental);
    _focusedDay = DateTime.now();
    _bookedDates = {}; // Initialize the map here
  }


  Future<void> _fetchPropertyDetails(String seoRental) async {
    final url = 'http://api-alpha.square1server.com/api/getrental1';
    final Map<String, String> queryParams = {
      "SEO_rental": seoRental,
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
        final List<dynamic> rentalRatesList = data['rentalRates'];
        setState(() {
          rentalRates = rentalRatesList.map((rate) {
            return {
              'Description': rate['Description'] ?? 'N/A',
              'Rate': rate['Rate'] ?? 'N/A',
              'CheckInDate': rate['CheckInDate'] ?? 'N/A',
              'CheckOutDate': rate['CheckOutDate'] ?? 'N/A',
            };
          }).toList();
        });
        final List<dynamic> availabilityList = data['availability'][0]['dates'];
        final Set<DateTime> newBookedDates = {};

        for (var availability in availabilityList) {
          final checkInDate = availability['CheckInDate'];
          final checkOutDate = availability['CheckOutDate'];
          final List<DateTime> datesInRange = _getDatesBetween(checkInDate, checkOutDate);
          newBookedDates.addAll(datesInRange);
        }

        setState(() {
          _bookedDates = newBookedDates; // Update booked dates
          // Handle other data
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
  List<DateTime> _getDatesBetween(String checkIn, String checkOut) {
    DateTime checkInDate = DateTime.parse(checkIn);
    DateTime checkOutDate = DateTime.parse(checkOut);
    List<DateTime> dates = [];

    for (int i = 0; i <= checkOutDate.difference(checkInDate).inDays; i++) {
      dates.add(checkInDate.add(Duration(days: i)));
    }

    return dates;
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
      });

      var userEmail = 'prabakarann1298@gmail.com';
      var password = 'jywrqugbvxyyvgtl';

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
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _questionText.clear();
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
            Navigator.pop(context);
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.property['bedroom'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Bed(S)',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.property['bathroom'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Bath(S)',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.property['sleepupto'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sleep Upto',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text('Description:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 6.0),
              ReadMoreText(
                widget.property['propertydesc'] ?? 'N/A',
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
                      spacing: 8.0, // Horizontal spacing between items
                      runSpacing: 4.0, // Vertical spacing between items
                      children: [
                        for (var i = 0; i < (amenityLabel?.split(', ') ?? []).length / 2; i++)
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                            child: Row(
                              children: [
                                Text('• ', style: TextStyle(fontSize: 16)), // Bullet point
                                Expanded(
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
                  ),
                  SizedBox(width: 8.0), // Space between the two columns
                  Expanded(
                    child: Wrap(
                      spacing: 8.0, // Horizontal spacing between items
                      runSpacing: 4.0, // Vertical spacing between items
                      children: [
                        for (var i = (amenityLabel?.split(', ') ?? []).length ~/ 2; i < (amenityLabel?.split(', ') ?? []).length; i++)
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                            child: Row(
                              children: [
                                Text('• ', style: TextStyle(fontSize: 16)), // Bullet point
                                Expanded(
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
                    'city': widget.property['city'] ?? 'Unknown Address',
                    'propertytype': widget.property['propertytype'] ?? 'Unknown Type',
                  },
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.indigo[900],
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        'available = ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                      Container(
                        width: 18.0,
                        height: 18.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black), // Optional border for visibility
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Unavailable = ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                      Container(
                        width: 18.0,
                        height: 18.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Select Dates:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              TableCalendar(
                firstDay: DateTime(2024),
                lastDay: DateTime(2025),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return _selectedDates.any((selectedDay) => isSameDay(day, selectedDay));
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
                  isTodayHighlighted: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    color: Colors.grey, // Set all other dates to grey circles
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
                          color: Colors.white, // Change black circle to white
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.black), // Change text color to black for visibility
                        ),
                      );
                    } else if (_unavailableDates.any((unavailableDay) => isSameDay(day, unavailableDay))) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: Colors.grey),
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
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey, // Grey circle for all other dates
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false, // Hide the format button
                  titleCentered: true, // Center the title (month and year)
                  formatButtonShowsNext: false, // Keep the view in month format only
                ),
              ),

              SizedBox(height: 16),
              Text(
                'Rate Information:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('CheckIn - CheckOut')),
                    ],
                    rows: rentalRates.map((rate) {
                      return DataRow(cells: [
                        DataCell(Text(rate['Description'])),
                        DataCell(Text('\$${rate['Rate']}')),
                        DataCell(Text('${rate['CheckInDate']} - ${rate['CheckOutDate']}')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 40),
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
                          Text(
                            'Request Information',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.property['propertyheadline'] ?? 'Property Headline',
                            style: TextStyle(color: Colors.black, fontSize: 20, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 25),
                          // Form fields go here
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
                                labelText: 'include Any Question and Answer Here',
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
                                return 'Please enter your Any Question and Answer Here';
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
              SizedBox(height: 16),
              Card(
                color: Colors.indigo[900],
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child:
                      Text(
                        'The information contained in this website does not serve as a substitute for an on-site visit to the vacation rental unit and should not be relied upon solely in the decision to rent the vacation unit. Coldwell Banker Sol Needles Real Estate makes no warranty of the accuracy of the information on this site or any site to which we link.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: Colors.white),
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
