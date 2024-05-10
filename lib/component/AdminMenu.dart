import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venue_x/Admin/AdminBookingNoti.dart';
import 'package:venue_x/Admin/AdminProfile.dart';
import 'package:venue_x/Screens/login_page.dart';

class AdminNavBar extends StatelessWidget {
  AdminNavBar({Key? key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('venueOwners').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Text('No data found');
          }

          var data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Text('No data found');
          }

          final venueOwnerId = data['venueOwnerId'].toString(); // Ensure venueOwnerId is a string

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(data['name'] ?? 'Admin'),
                accountEmail: Text(data['email'] ?? 'Admin@example.com\nVenue Owner ID: $venueOwnerId'), // Include venueOwnerId as a subtitle
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 71, 172, 255),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/user.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                    image: AssetImage('assets/images/bgimg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_2_outlined),
                    title: const Text("Profile"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bookmark_border_rounded),
                    title: const Text("Booking"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminBookingScreen(venueOwnerId: venueOwnerId)),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app_outlined),
                    title: const Text("Logout"),
                    onTap: () => _signOut(context),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
