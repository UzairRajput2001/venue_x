import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venue_x/Screens/login_page.dart';
import 'package:venue_x/User/userprofile.dart';
import 'package:venue_x/component/userNotification.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login screen widget
    );
  } catch (e) {
    print('Failed to sign out: $e');
    // Show error dialog or handle error
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to sign out. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const Text('No data found');
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return UserAccountsDrawerHeader(
                accountName: Text(userData['name'] ?? 'User'),
                accountEmail: Text(user.email ?? 'user@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 71, 172, 255),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/user2.png',
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
              );
            },
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_2_outlined),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserProfileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none_outlined),
                title: const Text("Notification"),
                onTap: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  NotificationScreen()));
                
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
      ),
    );
  }
}
