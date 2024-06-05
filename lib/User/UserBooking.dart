import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final String venueName;
  final DateTime selectedDate;
  final int selectedCapacity;
  final String selectedEvent;
  final String userId;

  const BookingScreen({
    super.key,
    required this.venueName,
    required this.selectedDate,
    required this.selectedCapacity,
    required this.selectedEvent,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: BackgroundPainter(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your booking request for $venueName has been sent!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Capacity: $selectedCapacity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Event: $selectedEvent',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw a circle
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.2),
      100,
      paint,
    );

    // Draw a rectangle
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * 0.8),
        width: 200,
        height: 150,
      ),
      paint,
    );

    // Draw another circle
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      50,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
