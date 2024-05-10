import 'package:flutter/material.dart';
import 'package:venue_x/Admin/adminhomepage.dart';
import 'package:venue_x/Screens/login_page.dart';
import 'package:venue_x/User/HomeVenueDetail.dart';
import 'package:venue_x/User/UserBooking.dart';
import 'package:venue_x/User/home_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VenueX',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      
      
      
    );
  }
}
