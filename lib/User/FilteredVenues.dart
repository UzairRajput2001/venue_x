import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/User/HomeVenueDetail.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';

class VenueListScreen extends StatelessWidget {
  final List<Venue> venues;

  const VenueListScreen({Key? key, required this.venues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return Card(
            
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: ListTile(
              title: Text(venue.name,
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[200])),
              subtitle: Text(
                  'Location: ${venue.location}, Event: ${venue.event_type}, Capacity: ${venue.capacity},Available Date: ${venue.dates}',
                  style: GoogleFonts.outfit(color: Colors.black,fontSize: 12)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VenueDetails(venue: venue),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
