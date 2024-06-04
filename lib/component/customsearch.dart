
import 'package:flutter/material.dart';
import 'package:venue_x/model.dart/venues_model.dart';


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
          }),
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
    for (var Venue in searchTerms) {
      if (Venue.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(Venue);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return const ListTile();
      },
    );
  }

  @override
Widget buildSuggestions(BuildContext context) {
  List<String> matchQuery = [];
    AllVenues().loadVenuesFromFirestore();
    searchTerms = AllVenues().getAllNames();
  for (var Venue in searchTerms) {
    if (Venue.toLowerCase().contains(query.toLowerCase())) {
      matchQuery.add(Venue);
    }
  }
  return ListView.builder(
    itemCount: matchQuery.length,
    itemBuilder: (context, index) {
      var result = matchQuery[index];
      return ListTile(
        title: Text(result),
        onTap: () {
          
        },
      );
    },
  );
}

}
