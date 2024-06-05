import 'package:flutter/material.dart';
import 'package:venue_x/model.dart/venue_model.dart';
import 'package:venue_x/User/HomeVenueDetail.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';

import '../model.dart/venues_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'saari Banquet 1',
    'qasim Banquet',
    'dolmen Banquet',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    
    AllVenues().loadVenuesFromFirestore();
    searchTerms = AllVenues().getAllNames();
    for (var venue in searchTerms) {
      if (venue.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(venue);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            // Fetch the venue details based on the name
            Venue? selectedVenue = AllVenues().getVenueByName(result);
            if (selectedVenue != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VenueDetails(venue: selectedVenue),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    AllVenues().loadVenuesFromFirestore();
    searchTerms = AllVenues().getAllNames();
    for (var venue in searchTerms) {
      if (venue.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(venue);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            // Fetch the venue details based on the name
            Venue? selectedVenue = AllVenues().getVenueByName(result);
            if (selectedVenue != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VenueDetails(venue: selectedVenue),
                ),
              );
            }
          },
        );
      },
    );
  }
}
