import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venue_x/User/chatscreen.dart';

class UserBookingRequestsScreen extends StatefulWidget {
  const UserBookingRequestsScreen({super.key});

  @override
  State<UserBookingRequestsScreen> createState() => _UserBookingRequestsScreenState();
}

class _UserBookingRequestsScreenState extends State<UserBookingRequestsScreen> {
  late List<Map<String, dynamic>> _bookingRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchBookingRequests();
  }

  Future<void> _fetchBookingRequests() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: 'active')
          .get();

      final List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'venueName': data['venueName'],
        };
      }).toList();

      setState(() {
        _bookingRequests = requests;
      });
    } catch (e) {
      print('Error fetching booking requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat with Admin'),
      ),
      body: ListView.builder(
        itemCount: _bookingRequests.length,
        itemBuilder: (context, index) {
          final booking = _bookingRequests[index];
          return Card(
            child: ListTile(
              title: Text(booking['venueName']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(documentId: booking['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
