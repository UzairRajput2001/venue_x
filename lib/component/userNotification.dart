import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/data/pushNotificationServices.dart';
import 'package:venue_x/model.dart/notificationmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          .where('status', isNotEqualTo: 'pending')
          .get();

      final List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'venueName': data['venueName'],
          'status': data['status'],
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
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: _bookingRequests.length,
        itemBuilder: (context, index) {
          final booking = _bookingRequests[index];
          final status = booking['status'];
          final statusColor = status == 'active' ? Colors.green : Colors.red;

          return ListTile(
            title: Text(booking['venueName']),
            trailing: Text(
              status,
              style: TextStyle(color: statusColor),
            ),
            
          );
        },
      ),
    );
  }
}
