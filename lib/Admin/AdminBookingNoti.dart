import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key, required String venueOwnerId});

  @override
  AdminBookingScreenState createState() => AdminBookingScreenState();
}

class AdminBookingScreenState extends State<AdminBookingScreen> {
  late List<BookingRequest> _bookingRequests;

 @override
void initState() {
  super.initState();
  _bookingRequests = []; // Initialize _bookingRequests as an empty list
  _fetchBookingRequests();
}

  Future<void> _fetchBookingRequests() async {
    try {
      final getVenueList=await FirebaseFirestore.instance.collection("venueOwners").doc(FirebaseAuth.instance.currentUser!.uid).get();
      List<String> venueList = getVenueList.get('venues').cast<String>();
      final querySnapshot = await FirebaseFirestore.instance.collection('bookingRequests').where("venueName",whereIn:venueList).get();
      final List<BookingRequest> requests = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final request = BookingRequest(
          venueName: data['venueName'] ?? '',
          selectedDate: (data['selectedDate'] as Timestamp).toDate(),
          selectedCapacity: data['selectedCapacity'] ?? '',
          id: doc.id,
        );
        requests.add(request);
      }
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
        title: const Text('My Bookings'),
      ),
      // ignore: unnecessary_null_comparison
      body: _bookingRequests != null
          ? ListView.builder(
              itemCount: _bookingRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Venue: ${_bookingRequests[index].venueName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${_bookingRequests[index].selectedDate.day}/${_bookingRequests[index].selectedDate.month}/${_bookingRequests[index].selectedDate.year}'),
                        Text('Capacity: ${_bookingRequests[index].selectedCapacity}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            _acceptBookingRequest(_bookingRequests[index].id);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _rejectBookingRequest(_bookingRequests[index].id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void _acceptBookingRequest(String requestId) {
    // Implement accept logic here
  }

  void _rejectBookingRequest(String requestId) {
    // Implement reject logic here
  }
}

class BookingRequest {
  final String id;
  final String venueName;
  final DateTime selectedDate;
  final int selectedCapacity; // Change to int

  BookingRequest({
    required this.id,
    required this.venueName,
    required this.selectedDate,
    required this.selectedCapacity,
  });

  factory BookingRequest.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BookingRequest(
      id: snapshot.id,
      venueName: data['venueName'] ?? '',
      selectedDate: (data['selectedDate'] as Timestamp).toDate(),
      selectedCapacity: data['selectedCapacity'] ?? 0, // Set default value or handle null
    );
  }
}
