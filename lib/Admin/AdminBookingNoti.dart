import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/data/pushNotificationServices.dart';

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

  // Function to show notification snackbar
  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Optional duration
      ),
    );
  }

  Future<void> _fetchBookingRequests() async {
    try {
      final getVenueList = await FirebaseFirestore.instance
          .collection("venueOwners")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      List<String> venueList = getVenueList.get('venues').cast<String>();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .where("venueName", whereIn: venueList)
          .get();
      final bookrequest = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .where("venueName", whereIn: venueList)
          .get();
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
                        Text(
                            'Date: ${_bookingRequests[index].selectedDate.day}/${_bookingRequests[index].selectedDate.month}/${_bookingRequests[index].selectedDate.year}'),
                        Text(
                            'Capacity: ${_bookingRequests[index].selectedCapacity}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            _acceptBookingRequest(_bookingRequests[index].id);
                            _showNotificationSnackBar("Booking Accepted");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _rejectBookingRequest(_bookingRequests[index].id);
                            _showNotificationSnackBar("Booking Rejected");
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

//   void _acceptBookingRequest(String requestId) {
//   // Implement accept logic here
//   PushNotificationService().showNotification(
//     "Booking Confirmed",
//     "Your booking has been confirmed.",
//   );
//   PushNotificationService().generateDeviceRegistrationToken();
// }

  void _acceptBookingRequest(String requestId) async {
    // Retrieve device token
    String? userDeviceToken =
        await PushNotificationService().generateDeviceRegistrationToken();
    DocumentReference bookingRef =
        FirebaseFirestore.instance.collection('bookingRequests').doc(requestId);

    // Update the status field
    await bookingRef.update({'status': 'active'});
    // Check if device token is available
    if (userDeviceToken != null) {
      // Implement accept logic here
      PushNotificationService().showNotification(
        // "Booking Confirmed",
        userDeviceToken,
        "Your booking has been accepted",
      );
    } else {
      print("Device token not available");
    }
  }

  void _rejectBookingRequest(String requestId) async {
    DocumentReference bookingRef =
        FirebaseFirestore.instance.collection('bookingRequests').doc(requestId);

    // Update the status field
    await bookingRef.update({'status': 'reject'});
    // Implement reject logic here
    PushNotificationService().showNotification(
        "Booking Rejected", "Your booking has been rejected try again.");
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
      selectedCapacity:
          data['selectedCapacity'] ?? 0, // Set default value or handle null
    );
  }
}
