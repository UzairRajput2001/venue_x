
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateVenueScreen extends StatefulWidget {
  const UpdateVenueScreen({
    super.key,
    required this.venueName,
    required this.venueDescription,
    required this.venueCapacity,
    required this.venueEventtype,
    required this.venueAddress,
    required this.venueLocation,
    required this.imageUrl,
  });
  final String venueName;
  final String venueDescription;
  final String venueLocation;
  final String venueCapacity;
  final String venueAddress;
  final String venueEventtype;
  final String imageUrl;

  @override
  UpdateVenueScreenState createState() => UpdateVenueScreenState();
}

class UpdateVenueScreenState extends State<UpdateVenueScreen> {
  File? _images;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController venueDescriptionController = TextEditingController();
  final TextEditingController venueCapacityController = TextEditingController();
  final TextEditingController venueLocationController = TextEditingController();
  final TextEditingController venueEventtypeController = TextEditingController();
  final TextEditingController venueAddressController = TextEditingController();

  Future<void> _getImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      venueNameController.text = widget.venueName;
      venueDescriptionController.text = widget.venueDescription;
      venueLocationController.text = widget.venueLocation;
      venueCapacityController.text = widget.venueCapacity;
      venueAddressController.text = widget.venueAddress;
      venueEventtypeController.text = widget.venueEventtype;
    });
  }

// trial code start

void updateData() async {
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  String imageUrl = widget.imageUrl; // Initial imageUrl from widget

  // Upload new image if selected
  if (_images != null && _images!.path.isNotEmpty) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('venues')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(_images!);
    imageUrl = await ref.getDownloadURL();
  }

  // Get the venue document reference
  final venueRef = FirebaseFirestore.instance
      .collection('venues')
      .where('userId', isEqualTo: userUid)
      .where('name', isEqualTo: widget.venueName);

  venueRef.get().then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document that matches the criteria
      final venueDoc = querySnapshot.docs[0];
      venueDoc.reference.update({
        'name': venueNameController.text,
        'description': venueDescriptionController.text,
        'Capacity': venueCapacityController.text,
        'venue_location': venueLocationController.text,
        'venue_Address': venueAddressController.text,
        'venue_eventtype': venueEventtypeController.text,
        "image_url": imageUrl,
        "available_dates": _selectedDates.map((date) => Timestamp.fromDate(date)).toList(),
      }).then((value) => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Venue updated successfully.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          )).onError((error, stackTrace) => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Failed'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the form
                    },
                  ),
                ],
              );
            },
          ));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Venue not found.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  });
}


// trail code 
  // void updateData() async {
  //   final userUid = FirebaseAuth.instance.currentUser!.uid;
  //   String imageUrl = "";
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('venues')
  //       .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
  //   if (_images!.path.isNotEmpty) {
  //     await ref.putFile(_images!);
  //     imageUrl = await ref.getDownloadURL();
  //   }
  //   final venueRef = FirebaseFirestore.instance
  //       .collection('venues')
  //       .where('userId', isEqualTo: userUid)
  //       .where('name', isEqualTo: widget.venueName);
  //   venueRef.get().then((querySnapshot) {
  //     final venueDoc = querySnapshot.docs[0];
  //     venueDoc.reference.update({
  //       'name': venueNameController.text,
  //       'description': venueDescriptionController.text,
  //       'Capacity': venueCapacityController.text,
  //       'venue_location': venueLocationController.text,
  //       'venue_Address': venueAddressController.text,
  //       'venue_eventtype': venueEventtypeController.text,
  //       "image_url": imageUrl,
  //       "available_dates": _selectedDates,
  //     }).then((value) => showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('Success'),
  //               content: const Text('Venue updated successfully.'),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('OK'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         )).onError((error, stackTrace) => showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('Failed'),
  //               content: Text(error.toString()),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('OK'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     // Reset the form
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         ));
  //   });
  // }

  final List<DateTime> _selectedDates = []; // List to store selected dates
  final TextEditingController _dateController = TextEditingController();

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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Update Venue'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Venue Details',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImagePickerButton(0),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueNameController,
                decoration: const InputDecoration(
                  labelText: 'Venue Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Venue Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueAddressController,
                decoration: const InputDecoration(
                  labelText: 'Venue Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueCapacityController,
                decoration: const InputDecoration(
                  labelText: 'Venue Capacity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueEventtypeController,
                decoration: const InputDecoration(
                  labelText: 'Venue EventType',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueLocationController,
                decoration: const InputDecoration(
                  labelText: 'Venue Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(labelText: 'Select Date'),
              ),
              _buildSelectedDatesList(),
              ElevatedButton(
                onPressed: updateData,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerButton(int index) {
    return IconButton(
      icon: _images != null ? SizedBox(height: 100, width: 200, child: Image.file(_images!)) : const Icon(Icons.add),
      onPressed: () => _getImage(index),
    );
  }
}

