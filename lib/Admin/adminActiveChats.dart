import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/Admin/AdminChatScreen.dart';

class AdminActiveBookingScreen extends StatefulWidget {
  const AdminActiveBookingScreen({super.key});

  @override
  AdminActiveBookingScreenState createState() => AdminActiveBookingScreenState();
}

class AdminActiveBookingScreenState extends State<AdminActiveBookingScreen> {
  late List<BookingRequest> _bookingRequests;

  @override
  void initState() {
    super.initState();
    _bookingRequests = [];
    _fetchBookingRequests();
  }

  Future<void> _fetchBookingRequests() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .where('status', isEqualTo: 'active')
          .get();

      final List<BookingRequest> requests = querySnapshot.docs
          .map((doc) => BookingRequest.fromSnapshot(doc))
          .toList();

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
        title: const Text('Active Bookings'),
      ),
      body: _bookingRequests.isNotEmpty
          ? ListView.builder(
              itemCount: _bookingRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_bookingRequests[index].venueName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminChatScreen(
                            documentId: _bookingRequests[index].id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class BookingRequest {
  final String id;
  final String venueName;

  BookingRequest({
    required this.id,
    required this.venueName,
  });

  factory BookingRequest.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BookingRequest(
      id: snapshot.id,
      venueName: data['venueName'] ?? '',
    );
  }
}
