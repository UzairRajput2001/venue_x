import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final String venueName;
  final DateTime selectedDate;
  final int selectedCapacity;
  final String selectedEvent;
  final String userId; // User ID

  const BookingScreen({
    Key? key,
    required this.venueName,
    required this.selectedDate,
    required this.selectedCapacity,
    required this.selectedEvent,
    required this.userId, // User ID
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your booking request for $venueName has been sent!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Capacity: $selectedCapacity',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Event: $selectedEvent',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
