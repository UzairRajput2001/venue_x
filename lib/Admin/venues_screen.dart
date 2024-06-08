
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/Admin/DeleteVenueScreen.dart';
import 'package:venue_x/Admin/updateScreen.dart';
import 'package:venue_x/model.dart/venue_model.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key, required this.routeName});
  final String routeName;

  @override
  State<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
 List<Venues>? venues=[];
  bool isLoading=false;
  Future<void> getVenues()async{
  setState(() {
    isLoading = true;
  });

  final querySnapshot = await FirebaseFirestore.instance
      .collection("venues")
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();

  venues = querySnapshot.docs.map((doc) => Venues.fromMap(doc.data())).toList();

  setState(() {
    isLoading = false;
  });

  print("Data ${querySnapshot.docs.length} documents found");
  }

  @override
  void initState()  {
    super.initState();
    getVenues().then((value) => print("Values printed"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const  Text("Edit Venues"),centerTitle: true),
      backgroundColor: Colors.white,
      body:isLoading?const Center(child: CircularProgressIndicator()): ListView.builder(
        itemCount: venues!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if(widget.routeName=="update")
              {
                  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  UpdateVenueScreen(
                    venueName: venues![index].name, 
                    venueEventtype: venues![index].eventType, 
                    venueCapacity: venues![index].capacity.toString(),
                  venueDescription: venues![index].description, 
                  venueAddress: venues![index].address, 
                  venueLocation: venues![index].venueLocation, 
                  imageUrl: venues![index].imageUrl,
                  ),
                ),
              );
              }
              else{
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  DeleteVenueScreen(
                  venueName: venues![index].name, 
                  venueDescription: venues![index].description, 
                  location: venues![index].venueLocation,
                   ),),);
              }
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
                    child:  venues![index].imageUrl.isEmpty ?null:Image.network(
                      venues![index].imageUrl,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      venues![index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Capacity: ${venues![index].capacity}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dates:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: venues![index].availableDates.map((date) {
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
      },),
    );
  }
}






