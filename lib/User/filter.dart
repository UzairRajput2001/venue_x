import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:venue_x/User/FilteredVenues.dart';
import 'package:venue_x/User/HomeVenueDetail.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedLocation = 'Select Location';
  String selectedEvent = 'Select Event';
  String selectedCapacity = 'Select Capacity';

  List<String> locations = ['Select Location', 'Hyderabad', 'Latifabad', 'Qasimabad'];
  List<String> events = ['Select Event', 'Marriage', 'Birthday', 'Others'];
  List<String> capacities = ['Select Capacity', '200 Peoples', '500 Peoples', '700 Peoples', 'more than 1000 Peoples'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                    onTap: () {
                      if (location != 'Select Location') {
                        setState(() {
                          selectedLocation = location;
                        });
                      }
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedEvent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: events.map((event) {
                  return DropdownMenuItem(
                    value: event,
                    child: Text(event),
                    onTap: () {
                      if (event != 'Select Event') {
                        setState(() {
                          selectedEvent = event;
                        });
                      }
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEvent = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCapacity,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: capacities.map((capacity) {
                  return DropdownMenuItem(
                    value: capacity,
                    child: Text(capacity),
                    onTap: () {
                      if (capacity != 'Select Capacity') {
                        setState(() {
                          selectedCapacity = capacity;
                        });
                      }
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCapacity = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  List<Venue> venues = await fetchVenuesFromFirestore();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VenueListScreen(venues: venues),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('Search', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Venue>> fetchVenuesFromFirestore() async {
  try {
    final venuesCollection = FirebaseFirestore.instance.collection('venues');
    Query query = venuesCollection;

    // Apply filters
    if (selectedLocation != 'Select Location') {
      query = query.where('venue_location', isEqualTo: selectedLocation);
    }
    if (selectedEvent != 'Select Event') {
      query = query.where('event_type', isEqualTo: selectedEvent);
    }
    if (selectedCapacity != 'Select Capacity') {
      int capacityLowerBound = 0;
      int capacityUpperBound = 0;
      
      switch (selectedCapacity) {
        case '200 Peoples':
          capacityLowerBound = 0;
          capacityUpperBound = 200;
          break;
        case '500 Peoples':
          capacityLowerBound = 201;
          capacityUpperBound = 500;
          break;
        case '700 Peoples':
          capacityLowerBound = 501;
          capacityUpperBound = 700;
          break;
        case 'more than 1000 Peoples':
          capacityLowerBound = 701;
          break;
        default:
          break;
      }

      if (capacityLowerBound > 0) {
        query = query.where('capacity', isGreaterThanOrEqualTo: capacityLowerBound);
      }
      if (capacityUpperBound > 0) {
        query = query.where('capacity', isLessThanOrEqualTo: capacityUpperBound);
      }
    }

    QuerySnapshot querySnapshot = await query.get();

    print('Fetched ${querySnapshot.docs.length} venues.');

    List<Venue> venues = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Venue(
        imagePath: data['image_url'] ?? '',
        name: data['name'] ?? '',
        capacity: data['capacity'] ?? 0,
        dates: (data['available_dates'] as List<dynamic>?)
            ?.map((timestamp) => (timestamp as Timestamp).toDate())
            .toList() ?? [],
        description: data['description'] ?? '',
        address: data['address'] ?? '',
        event_type: data['event_type'] ?? '',
        location: data['venue_location'] ?? '',
      );
    }).toList();

    return venues;

  } catch (e) {
    print('Error fetching venues: $e');
    return []; // Return an empty list if there's an error
  }
}
}
