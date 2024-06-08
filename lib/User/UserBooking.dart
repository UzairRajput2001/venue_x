import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final String venueName;
  final DateTime selectedDate;
  final int selectedCapacity;
  final String selectedEvent;
  final String userId;
  final String location;
  final List<dynamic> dates;

  const BookingScreen({
    super.key,
    required this.venueName,
    required this.selectedDate,
    required this.selectedCapacity,
    required this.selectedEvent,
    required this.userId,
    required this.location,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(child: Text('Booking Confirmation',style: GoogleFonts.outfit(fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
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
                      style: GoogleFonts.outfit(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade200),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color.fromARGB(
                            156, 94, 83, 83), // Customize the color
                        thickness: 1, // Customize the thickness
                      ),
                    ),
                    Text(
                      'Current Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color.fromARGB(
                            156, 94, 83, 83), // Customize the color
                        thickness: 1, // Customize the thickness
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_alt_outlined),
                          const SizedBox(width: 8.0,),
                          Text(
                            'Capacity: $selectedCapacity',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color.fromARGB(
                            156, 94, 83, 83), // Customize the color
                        thickness: 1, // Customize the thickness
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.celebration_outlined),
                          const SizedBox(width: 8.0),
                          Text(
                            'Event: $selectedEvent',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color.fromARGB(
                            156, 94, 83, 83), // Customize the color
                        thickness: 1, // Customize the thickness
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.place_outlined),
                          const SizedBox(width: 8.0,),
                          Text(
                            'Location: ${location}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color.fromARGB(
                            156, 94, 83, 83), // Customize the color
                        thickness: 1, // Customize the thickness
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          
                          color: Colors.deepPurpleAccent, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.date_range_rounded),
                                  Text(
                                    'Booking Date: ',
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigoAccent[200]
                                    ),
                                  ),
                                  Row(
                                    
                                    children: dates.map((date) {
                                      return Text(
                                        date,
                                        style: GoogleFonts.lato(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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


