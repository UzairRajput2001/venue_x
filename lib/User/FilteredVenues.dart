import 'package:flutter/material.dart';
import 'package:venue_x/User/HomeVenueDetail.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';

class VenueListScreen extends StatelessWidget {
  final List<Venue> venues;

  const VenueListScreen({Key? key, required this.venues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Venues'),
      ),
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return Card(
            child: ListTile(
              title: Text(venue.name),
              subtitle: Text('Location: ${venue.location}, Event: ${venue.event_type}, Capacity: ${venue.capacity}'),
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
