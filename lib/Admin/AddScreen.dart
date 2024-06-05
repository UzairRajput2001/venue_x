
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:venue_x/model.dart/venues_model.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  _AddVenueScreenState createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  final ImagePicker _picker = ImagePicker();
  late File _image = File(''); // Initialize with an empty File object
  String _venueName = '';
  String _venueDescription = '';
  String _venueAddress = '';
  String _capacity = '100'; // Default capacity
  String _eventType = 'Marriage'; // Default event type
  String _venueLocation = 'Hyderabad'; // Default venue location
  List<DateTime> _selectedDates = []; // List to store selected dates
  final TextEditingController _dateController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> _autoCompleteKey = GlobalKey();

  List<String> _suggestions = [
    'Venue 1',
    'Venue 2',
    'Venue 3',
    // Add more venue names here or fetch from Firestore
  ];


  Widget _buildVenueNameTextField() {
    AllVenues().loadVenuesFromFirestore();
    _suggestions = AllVenues().getAllNames();
    return AutoCompleteTextField<String>(
      key: _autoCompleteKey,
      clearOnSubmit: false,
      suggestions: _suggestions,
      decoration: const InputDecoration(labelText: 'Venue Name'),
      itemFilter: (String suggestions, String query) {
        return suggestions.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (String a, String b) {
        return a.compareTo(b);
      },
      itemSubmitted: (String venueName) {
        setState(() {
          _venueName = venueName;
        });
      },
      itemBuilder: (BuildContext context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
    );
  }
   Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVenue() async {
    // Upload image to Firebase Storage
    String imageUrl = "";
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('venues')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    if (_image.path.isNotEmpty) {
      await ref.putFile(_image);
      imageUrl = await ref.getDownloadURL();
    }
    Map<String, dynamic> venueDetails = {
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'name': _venueName,
      'description': _venueDescription,
      'image_url': imageUrl,
      'address': _venueAddress, // Store venue address
      'capacity': int.parse(_capacity), // Convert capacity to int
      'event_type': _eventType,
      'venue_location': _venueLocation,
      'available_dates': _selectedDates.map((date) => DateFormat('yyyy-MM-dd').format(date)).toList(), // Convert dates to string format
    };

    // Upload venue details to Firestore
    await FirebaseFirestore.instance.collection('venues').add(venueDetails);

    CollectionReference venuesRef = FirebaseFirestore.instance.collection('venueOwners');
    DocumentReference venueDocRef = venuesRef.doc(FirebaseAuth.instance.currentUser!.uid);
    // Update the document
    await venueDocRef.update({
      'venues': FieldValue.arrayUnion([_venueName]),
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Venue added successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Reset the form
                setState(() {
                  _image = File(''); // Empty file
                  _venueName = '';
                  _venueDescription = '';
                  _venueAddress = '';
                  _capacity = '100'; // Reset to default capacity
                  _eventType = 'Marriage'; // Reset to default event type
                  _venueLocation = 'Hyderabad'; // Reset to default venue location
                  _selectedDates = []; // Clear selected dates
                  _dateController.clear(); // Clear date controller
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)), // Allow selection of past year for a year
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDates.add(pickedDate);
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Widget _buildSelectedDatesList() {
    if (_selectedDates.isEmpty) {
      return const Text('No dates selected yet.');
    }

    return ListView.builder(
      shrinkWrap: true, // Prevent excessive scrolling for short lists
      itemCount: _selectedDates.length,
      itemBuilder: (context, index) {
        final selectedDate = _selectedDates[index];
        return ListTile(
          title: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _selectedDates.removeAt(index);
                _dateController.text = ''; // Clear the text field on removal
              });
            },
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Venue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image.path.isEmpty
                      ? const Center(child: Icon(Icons.add_a_photo))
                      : Image.file(_image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              _buildVenueNameTextField(),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) => _venueDescription = value,
                decoration: const InputDecoration(labelText: 'Venue Description'),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) => _venueAddress = value,
                decoration: const InputDecoration(labelText: 'Venue Address'),
              ),
               const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _capacity,
                onChanged: (value) {
                  setState(() {
                    _capacity = value!;
                  });
                },
                items: ['100', '200', '500', '1000 or more'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Capacity'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _eventType,
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
                items: ['Marriage', 'Birthday Party', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Event Type'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _venueLocation,
                onChanged: (value) {
                  setState(() {
                    _venueLocation = value!;
                  });
                },
                items: ['Hyderabad', 'Qasimabad', 'Latifabad', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Venue Location'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(labelText: 'Select Date'),
              ),
              const SizedBox(height: 10),
              _buildSelectedDatesList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _uploadVenue();
                },
                child: const Text('Save Venue'),
              ),

              // Rest of the UI remains the same...
            ],
          ),
        ),
      ),
    );
  }
}
