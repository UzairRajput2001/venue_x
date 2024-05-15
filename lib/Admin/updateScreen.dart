import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVenueScreen extends StatefulWidget {
  const UpdateVenueScreen({super.key, required this.venueName, 
  required this.venueDescription, 
  required this.venueLocation, required this.imageUrl,
  });
  final String venueName;
  final String venueDescription;
  final String venueLocation;
  final String imageUrl;

  @override
  UpdateVenueScreenState createState() => UpdateVenueScreenState();
}

class UpdateVenueScreenState extends State<UpdateVenueScreen> {

   File? _images;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController venueNameController=TextEditingController();
  final TextEditingController venueDescriptionController=TextEditingController();
  final TextEditingController venueLocationController=TextEditingController();

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
      venueNameController.text=widget.venueName;
      venueDescriptionController.text=widget.venueDescription;
      venueLocationController.text=widget.venueLocation;
    });
  }

  void updateData()async{
  final userUid = FirebaseAuth.instance.currentUser!.uid;
    String imageUrl="";
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('venues')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    if(_images!.path.isNotEmpty)
    {
      await ref.putFile(_images!);
      imageUrl = await ref.getDownloadURL();
    }
  final venueRef = FirebaseFirestore.instance
  .collection('venues')
  .where('userId', isEqualTo: userUid)
  .where('name',isEqualTo: widget.venueName);
  venueRef.get().then((querySnapshot) {
    final venueDoc = querySnapshot.docs[0];
    venueDoc.reference.update({
      'name': venueNameController.text,
      'description': venueDescriptionController.text,
      'venue_location': venueLocationController.text,
      "image_url":imageUrl,
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
          content:  Text(error.toString()),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Venue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update Venue Details',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImagePickerButton(0),
                // _buildImagePickerButton(1),
                // _buildImagePickerButton(2),
              ],
            ),
            const SizedBox(height: 20),
             TextField(
             controller:  venueNameController,
              decoration:const  InputDecoration(
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
              controller: venueLocationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Add more fields as needed
            ElevatedButton(
              onPressed: () {
               updateData();// Return to the previous screen
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerButton(int index) {
    return IconButton(
      icon: _images != null ? SizedBox(height: 100,width:200, child: Image.file(_images!)) : const Icon(Icons.add),
      onPressed: () => _getImage(index),
    );
  }
}
