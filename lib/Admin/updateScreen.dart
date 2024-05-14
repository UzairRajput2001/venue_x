import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVenueScreen extends StatefulWidget {
  const UpdateVenueScreen({super.key});

  @override
  UpdateVenueScreenState createState() => UpdateVenueScreenState();
}

class UpdateVenueScreenState extends State<UpdateVenueScreen> {

  final List<File?> _images = [null, null, null];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController venueNameController=TextEditingController();
  final TextEditingController venueDescriptionController=TextEditingController();
  final TextEditingController venueLocationController=TextEditingController();

  Future<void> _getImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  // void updateData()async{
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference collection = firestore.collection('venues');
  //   DocumentReference document = collection.doc();
  //   Map<String, dynamic> updatedData = {
  //     'fieldName1': ,
  //     'fieldName2': newValue2,
  //     ""
  // // ... other fields to update
  //   };

  // document.update(updatedData).then((_) {
  //   print('Document updated successfully!');
  // }).catchError((error) {
  //     print('Error updating document: $error');
  //   });
  // }

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerButton(0),
                _buildImagePickerButton(1),
                _buildImagePickerButton(2),
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
                Navigator.pop(context); // Return to the previous screen
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
      icon: _images[index] != null ? Image.file(_images[index]!) : const Icon(Icons.add),
      onPressed: () => _getImage(index),
    );
  }
}
