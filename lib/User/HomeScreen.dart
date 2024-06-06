import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/User/HomeVenueDetail.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';

// class Venue {
//   final String imagePath;
//   final String name;
//   final int capacity;
//   final String date;

//   Venue({
//     required this.imagePath,
//     required this.name,
//     required this.capacity,
//     required this.date,
//   });
// }

class DetailsVenues extends StatefulWidget {
  const DetailsVenues({super.key});

  @override
  State<DetailsVenues> createState() => _DetailsVenuesState();
}

class _DetailsVenuesState extends State<DetailsVenues> {
  late List<Venue> venues = [];

  @override
  void initState() {
    super.initState();
    fetchVenuesFromFirestore().then((fetchedVenues) {
      setState(() {
        venues = fetchedVenues;
      });
      print("venue Lenght ${venues.length}");
    });
  }

  Future<List<Venue>> fetchVenuesFromFirestore() async {
    try {
      final venuesCollection = FirebaseFirestore.instance.collection('venues');
      final querySnapshot = await venuesCollection.get();

      print('Fetched ${querySnapshot.docs.length} venues.');

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Venue(
          imagePath: data['image_url'],
          name: data['name'],
          capacity: data['capacity'],
          dates: (data['available_dates']),
          description: data['description'],
          address: data['address'],
          event_type: data['event_type'],
          location: data['venue_location'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching venues: $e');
      return []; // Return an empty list if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Venues'),
      ),
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VenueDetails(
                    venue: venue,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: venue.imagePath.isEmpty
                        ? const SizedBox.shrink()
                        : Image.network(
                            venue.imagePath,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          venue.name,
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20.0,
                        ),
                            Text(
                            venue.capacity.toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          ]
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Color.fromARGB(
                          156, 94, 83, 83), // Customize the color
                      thickness: 0.5, // Customize the thickness
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: venue.dates.map((date) {
                            return Text(
                              date,
                              style: const TextStyle(fontSize: 12),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
