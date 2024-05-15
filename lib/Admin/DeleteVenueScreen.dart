import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteVenueScreen extends StatefulWidget {
  final String venueName;
  final String venueDescription;
  final String location;

  const DeleteVenueScreen({super.key, required this.venueName, required this.venueDescription, required this.location});

  @override
  State<DeleteVenueScreen> createState() => _DeleteVenueScreenState();
}

class _DeleteVenueScreenState extends State<DeleteVenueScreen> {
  void delete()async{
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  final venueRef = FirebaseFirestore.instance
  .collection('venues')
  .where('userId', isEqualTo: userUid)
  .where('name',isEqualTo: widget.venueName);
  venueRef.get().then((querySnapshot) {
    final venueDoc = querySnapshot.docs[0];
    venueDoc.reference.delete().then((value) => showDialog(
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
        title: const Text('Delete Venue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Venue Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${widget.venueName}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${widget.venueDescription}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: ${widget.location}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Venue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this venue?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
               delete();
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to the previous screen
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
