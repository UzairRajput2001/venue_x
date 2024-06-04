import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venues'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('venues').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No venues available.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> venueData = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(venueData['name']),
                subtitle: Text(venueData['description']),
                // You can display other details here as well
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
