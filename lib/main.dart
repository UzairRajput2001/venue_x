import 'package:flutter/material.dart';
import 'package:venue_x/Screens/login_page.dart';
import 'package:venue_x/Admin/adminhomepage.dart';
import 'package:venue_x/User/home_page.dart';
import 'package:venue_x/data/push_notification.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotificationService().initNotifications();
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
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            return LoginPage();
          } else {
            return FutureBuilder(
              future: _checkUserRole(user.uid),
              builder: (context, AsyncSnapshot<bool> roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.done) {
                  if (roleSnapshot.data == true) {
                    return const AdminHome();
                  } else {
                    return const HomePage();
                  }
                } else {
                  return Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ));
                  ;
                }
              },
            );
          }
        } else {
          return Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ));
        }
      },
    );
  }

  Future<bool> _checkUserRole(String uid) async {
    DocumentSnapshot venueOwnerSnapshot = await FirebaseFirestore.instance
        .collection('venueOwners')
        .doc(uid)
        .get();
    return venueOwnerSnapshot.exists;
  }
}
