import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<BookingRequest>>(
        future: _fetchBookingRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<BookingRequest> bookingRequests = snapshot.data ?? [];
            return ListView.builder(
              itemCount: bookingRequests.length,
              itemBuilder: (context, index) {
                final bookingRequest = bookingRequests[index];
                return Card(
                  child: ListTile(
                    title: Text(_getNotificationTitle(bookingRequest)),
                    subtitle: Text('Venue: ${bookingRequest.venueName}',style:GoogleFonts.outfit(color: Colors.indigoAccent)), // Add more details if needed
                    onTap: () {
                      // Handle notification tap
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<BookingRequest>> _fetchBookingRequests() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .where('userId', isEqualTo: userId)
          .get();
      List<BookingRequest> bookingRequests = querySnapshot.docs
          .map((doc) => BookingRequest.fromSnapshot(doc))
          .toList();
      return bookingRequests;
    } catch (e) {
      print('Error fetching booking requests: $e');
      return []; // Return an empty list if there's an error
    }
  }

  String _getNotificationTitle(BookingRequest bookingRequest) {
    if (bookingRequest.status == 'active') {
      return 'Your Booking Accepted';
    } else if (bookingRequest.status == 'reject') {
      return 'Your Booking Rejected';
    } else {
      return 'New Booking Added '; // Default title if status is neither active nor rejected
    }
  }
}

class BookingRequest {
  final String id;
  final String status;
  final String venueName;
  // Add more fields as needed

  BookingRequest({
    required this.id,
    required this.status,
    required this.venueName,
    // Add more fields as needed
  });

  factory BookingRequest.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BookingRequest(
      id: snapshot.id,
      status: data['status'] ?? '',
      venueName: data['venueName'] ?? '',
      // Extract other fields from data
    );
  }
}
