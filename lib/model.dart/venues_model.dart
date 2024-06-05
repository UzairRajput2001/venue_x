import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';

class AllVenues {
  // Private constructor
  AllVenues._internal();

  // Static private instance of the class
  static final AllVenues _instance = AllVenues._internal();

  // Factory constructor to return the same instance every time
  factory AllVenues() {
    return _instance;
  }

  // Example property
  String exampleProperty = 'Hello, Singleton!';

  // List to store venues
  List<Venue> venues = [];

  // Method to add a venue
  void addVenue(Venue venue) {
    venues.add(venue);
  }

  // Method to retrieve all venues
  List<Venue> getAll() {
    return venues;
  }

  // Method to load venues from Firestore
  Future<void> loadVenuesFromFirestore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('venues').get();
    venues = querySnapshot.docs.map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>)).toList();

  }

  // Method to get all venue names
  List<String> getAllNames() {
    return venues.map((venue) => venue.name).toList();
  }

  // Method to get a venue by name
  Venue? getVenueByName(String name) {
    try {
      return venues.firstWhere((venue) => venue.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      return null; // Return null if no venue is found
    }
  }
}
