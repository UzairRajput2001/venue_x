import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/User/HomeScreen.dart';
import 'package:venue_x/User/chat_page.dart';
import 'package:venue_x/User/chatscreen.dart';
import 'package:venue_x/User/filter.dart';
import 'package:venue_x/User/userprofile.dart';
import 'package:venue_x/component/customsearch.dart';
import 'package:venue_x/component/drawer.dart';
import 'package:venue_x/data/pushNotificationServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _venueName = 'Qasim Banquet';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkForUpdates();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _currentIndex = 1;
  late List<Widget> body;

  List<Map<String, dynamic>>? previousRequestsData;

  Future<void> checkForUpdates() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch current requests data
    final currentRequestsSnapshot = await FirebaseFirestore.instance
        .collection('bookingRequests')
        .where("userId", isEqualTo: userId)
        .get();

    final List<Map<String, dynamic>> currentRequestsData =
        currentRequestsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

    // Compare with previous requests data
    if (previousRequestsData != null) {
      final isDifferent =
          !_areListsEqual(previousRequestsData!, currentRequestsData);

      if (isDifferent) {
        print("new update");
        PushNotificationService().showNotification(
          "new update",
          "Status has changed to:",
        );
      }
    }

    // Update previous requests data
    previousRequestsData = currentRequestsData;
  }

  bool _areListsEqual(
      List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (!_areMapsEqual(list1[i], list2[i])) {
        return false;
      }
    }
    return true;
  }

  bool _areMapsEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) {
      return false;
    }

    for (final key in map1.keys) {
      if (map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    body = [
      const UserProfileScreen(),
      const DetailsVenues(),
      UserBookingRequestsScreen(),
    ];
    _startTimer();
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Center(child: Text('Search for venues')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterScreen()),
                );
              },
              icon: const Icon(Icons.filter_alt_outlined),
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outlined), label: 'Chat'),
        ],
      ),
    );
  }
}
