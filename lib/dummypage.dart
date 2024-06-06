import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Define the Venue class
class Venue {
  final String imagePath;
  final String name;
  final int capacity;
  final List<String> dates;

  Venue({
    required this.imagePath,
    required this.name,
    required this.capacity,
    required this.dates,
  });
}

// Custom card component
class VenueCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int capacity;
  final List<String> dates;

  VenueCard({
    required this.imageUrl,
    required this.name,
    required this.capacity,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        width: 300,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Capacity: $capacity',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Available Dates: ${dates.join(', ')}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to fetch venues from Firestore
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
        dates: List<String>.from(data['available_dates']),
      );
    }).toList();
  } catch (e) {
    print('Error fetching venues: $e');
    return []; // Return an empty list if there's an error
  }
}

class DummyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Card Example')),
        body: FutureBuilder<List<Venue>>(
          future: fetchVenuesFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No venues available'));
            }

            final venues = snapshot.data!;

            return ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return VenueCard(
                  imageUrl: venue.imagePath,
                  name: venue.name,
                  capacity: venue.capacity,
                  dates: venue.dates,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
