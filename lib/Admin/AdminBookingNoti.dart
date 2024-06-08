import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          .where("venueName", whereIn: venueList).where('status',isEqualTo: 'pending')
          .get();
      final List<BookingRequest> requests = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final request = BookingRequest(
          venueName: data['venueName'] ?? '',
          selectedDate: (data['selectedDate'] as Timestamp).toDate(),
          selectedCapacity: data['selectedCapacity'] ?? '',
          id: doc.id,
          userDeviceToken: data['userDeviceToken'] ?? '',
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

      ),
      // ignore: unnecessary_null_comparison
      body: _bookingRequests != null
          ? ListView.builder(
              itemCount: _bookingRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Venue: ${_bookingRequests[index].venueName}',style: GoogleFonts.lato(color: Colors.indigo[200]),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Date: ${_bookingRequests[index].selectedDate.day}/${_bookingRequests[index].selectedDate.month}/${_bookingRequests[index].selectedDate.year}',style: GoogleFonts.lato(color: Colors.black),),
                        Text(
                            'Capacity: ${_bookingRequests[index].selectedCapacity}',style: GoogleFonts.lato(color: Colors.black),),
                      ],
                    ),
                    trailing: 
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check,color: Colors.green,),
                          onPressed: () {
                            _acceptBookingRequest(_bookingRequests[index].id, _bookingRequests[index].userDeviceToken);
                            _showNotificationSnackBar("Booking Accepted");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,color: Colors.red),
                          onPressed: () {
                            _rejectBookingRequest(_bookingRequests[index].id, _bookingRequests[index].userDeviceToken);
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

  void _acceptBookingRequest(String requestId, String userDeviceToken) async {
    final _currentUser =FirebaseAuth.instance.currentUser!.uid;
    DocumentReference bookingRef =
        FirebaseFirestore.instance.collection('bookingRequests').doc(requestId);

    CollectionReference chatsRef = bookingRef.collection('chats');

    await chatsRef.add({
      'sender': 'Admin',
      'message': 'Your booking has been accepted',
      'timestamp': DateTime.now(),
    });

    await bookingRef.update({'status': 'active', 'adminId':_currentUser});

    if (userDeviceToken.isNotEmpty) {
      PushNotificationService().showNotification(
        userDeviceToken,
        "Your booking has been accepted",
      );
    } else {
      print("User device token not available");
    }
    setState(() {
       _fetchBookingRequests();
    });
  }

  void _rejectBookingRequest(String requestId, String userDeviceToken) async {
    DocumentReference bookingRef =
        FirebaseFirestore.instance.collection('bookingRequests').doc(requestId);

    // CollectionReference chatsRef = bookingRef.collection('chats');

    // await chatsRef.add({
    //   'sender': 'Admin',
    //   'message': 'Your booking has been rejected',
    //   'timestamp': DateTime.now(),
    // });

    await bookingRef.update({'status': 'rejected'});

    if (userDeviceToken.isNotEmpty) {
      PushNotificationService().showNotification(
        userDeviceToken,
        "Your booking has been rejected",
      );
    } else {
      print("User device token not available");
    }
    setState(() {
       _fetchBookingRequests();
    });
  }
}

class BookingRequest {
  final String id;
  final String venueName;
  final DateTime selectedDate;
  final int selectedCapacity; // Change to int
  final String userDeviceToken; // Add this field

  BookingRequest({
    required this.id,
    required this.venueName,
    required this.selectedDate,
    required this.selectedCapacity,
    required this.userDeviceToken, // Add this parameter
  });

  factory BookingRequest.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BookingRequest(
      id: snapshot.id,
      venueName: data['venueName'] ?? '',
      selectedDate: (data['selectedDate'] as Timestamp).toDate(),
      selectedCapacity: data['selectedCapacity'] ?? 0, // Set default value or handle null
      userDeviceToken: data['userDeviceToken'] ?? '', // Add this line
    );
  }
}
