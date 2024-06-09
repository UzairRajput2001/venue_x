import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:venue_x/User/UserBooking.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VenueDetails extends StatefulWidget {
  final Venue venue;

  const VenueDetails({super.key, required this.venue});

  @override
  VenueDetailsState createState() => VenueDetailsState();
}

class VenueDetailsState extends State<VenueDetails> {
  late DateTime _selectedDate;
  late String _selectedEvent;
  late String _selectedCapacity;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedEvent = 'Select Event';
    _selectedCapacity = 'Select Capacity';
  }

  // Function to add a new booking request to Firestore
  Future<void> _addBookingRequest() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the current user's ID
        String userId = user.uid;

        // Add the booking request with the user's ID
        await FirebaseFirestore.instance
            .collection('bookingRequests')
            .add({
              'venueName': widget.venue.name,
              'userId': userId,
              'selectedDate': _selectedDate,
              'selectedEvent': widget.venue.event_type,
              'selectedCapacity': widget.venue.capacity,
              'status': 'pending', // Initial status is pending
            })
            .then((DocumentReference doc) => print("Document ID: ${doc.id}"))
            .catchError((error) => print("Error $error"));

        // Navigate to the booking screen after adding the request
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              venueName: widget.venue.name,
              selectedDate: _selectedDate,
              selectedEvent: widget.venue.event_type,
              selectedCapacity: widget.venue.capacity,
              userId: userId,
              location: widget.venue.location,
              dates: widget.venue.dates,
            ),
          ),
        );

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking request sent')),
        );
      }
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending booking request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: ListView(
        children: [
          // Image
          SizedBox(
            height: 200.0,
            child: widget.venue.imagePath.isEmpty
                ? const SizedBox.shrink()
                : Image.network(
                    widget.venue.imagePath,
                    fit: BoxFit.cover,
                  ),
          ),
          // Name

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.venue.name,
              style: GoogleFonts.lato(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color:  Colors.indigo[300]),
            ),
          ),
          const SizedBox(height: 4,),

          // Description
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurpleAccent, // Border color
                width: 2.0, // Border width
              ),
              borderRadius: BorderRadius.circular(16.0), // Border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.venue.description,
                style: GoogleFonts.outfit(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Address: ${widget.venue.address}',
              style: GoogleFonts.outfit(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Color.fromARGB(156, 167, 151, 255), // Customize the color
              thickness: 1, // Customize the thickness
            ),
          ),
          // Capacity
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.people_alt_outlined,color: Colors.indigo[300]),
                Text(
                  ' Capacity: ${widget.venue.capacity}',
                  style: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[300]),
                ),
              ],
            ),
          ),
          // Event Type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.celebration_outlined,color: Colors.indigo[300]),
                Text(
                  'Event Type: ${widget.venue.event_type}',
                  style: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[300]),
                ),
              ],
            ),
          ),
          // Location
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 Icon(Icons.place_outlined,color: Colors.indigo[300]),
                Text(
                  'Location: ${widget.venue.location}',
                  style: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[300]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Color.fromARGB(156, 94, 83, 83), // Customize the color
              thickness: 1, // Customize the thickness
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.date_range_rounded),
                    Text(' Available Date: ',
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.venue.dates.map((date) {
                        return Text(
                          date,
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Color.fromARGB(156, 94, 83, 83), // Customize the color
              thickness: 1, // Customize the thickness
            ),
          ),

          // Book Now Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await _addBookingRequest();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: const Text(
                'Send Booking Request',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
