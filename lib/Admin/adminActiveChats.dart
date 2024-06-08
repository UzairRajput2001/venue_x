import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final _currentUser = FirebaseAuth.instance.currentUser!.uid;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .where('status', isEqualTo: 'active')
          .where('adminId', isEqualTo: _currentUser)
          .get();

      final List<BookingRequest> requests = [];
      for (final doc in querySnapshot.docs) {
      
        final data = doc.data() as Map<String, dynamic>;
        final userName = await _fetchUserName(data['userId']);
        final venueName = data['venueName'];
        requests.add(BookingRequest(id: doc.id, userName: userName, venueName:venueName ));
      }

      setState(() {
        _bookingRequests = requests;
      });
    } catch (e) {
      print('Error fetching booking requests: $e');
    }
  }

  Future<String> _fetchUserName(String userId) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['name'] ?? 'Unknown';
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text('Chat With Users',style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        
      ),
      body: _bookingRequests.isNotEmpty
          ? ListView.builder(
              itemCount: _bookingRequests.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_bookingRequests[index].userName,style: TextStyle(color: Colors.indigoAccent[200])),
                    subtitle: Text(_bookingRequests[index].venueName,style: TextStyle(color: Colors.black)),
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
  final String userName;
  final String venueName;

  BookingRequest({
    required this.id,
    required this.userName,
    required this.venueName,

  });
}
