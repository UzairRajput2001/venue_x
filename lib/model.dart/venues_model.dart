
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venue_x/model.dart/venue_model.dart';

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
  List<Venues> venues = [];

  // Method to add a venue
  void addVenue(Venues venue) {
    venues.add(venue);
  }

  // Method to retrieve all venues
  List<Venues> getAll() {
    return venues;
  }

  // Method to load venues from Firestore
  Future<void> loadVenuesFromFirestore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('venues').get();
    venues = querySnapshot.docs.map((doc) => Venues.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  // Method to get all venue names
  List<String> getAllNames() {
    return venues.map((venue) => venue.name).toList();
  }
  // // Example method
  // void exampleMethod() {
  //   print(exampleProperty);
  // }
}
