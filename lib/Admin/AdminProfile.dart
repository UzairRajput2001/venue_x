import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('venueOwners').doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox( height:20,width: 20,child: Center(child:  CircularProgressIndicator(),),);
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return const Center(child: Text('No data found'));
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    // Use the user's profile image from Firestore
                    backgroundImage: AssetImage('assets/images/user2.png'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Name: ${data['name']}',
                    style: GoogleFonts.outfit(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Email: ${data['email']}',
                    style:  GoogleFonts.outfit(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Phone Number: ${data['phone']}',
                    style:  GoogleFonts.outfit(fontSize: 20),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
