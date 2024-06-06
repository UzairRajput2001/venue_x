// import 'package:untitled1/Screens/Welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venue_x/Admin/adminhomepage.dart';
import 'package:venue_x/Screens/login_page.dart';
import 'package:venue_x/User/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If the user is not logged in, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Check the user's role
      bool isAdmin = await _checkUserRole(user.uid);
      if (isAdmin) {
        // Navigate to the admin home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
      } else {
        // Navigate to the user home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
  }

  Future<bool> _checkUserRole(String uid) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('venueOwners')
        .doc(uid)
        .get();
    return userSnapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }
}