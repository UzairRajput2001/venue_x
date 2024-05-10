import 'package:flutter/material.dart';
import 'package:venue_x/User/HomeScreen.dart';
import 'package:venue_x/User/chatscreen.dart';
import 'package:venue_x/User/filter.dart';
import 'package:venue_x/User/userprofile.dart';
import 'package:venue_x/component/customsearch.dart';
import 'package:venue_x/component/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _venueName = 'Qasim Banquet';

  int _currentIndex = 1;
  late List<Widget> body;

  @override
  Widget build(BuildContext context) {
    body = [
      const UserProfileScreen(),
      const DetailsVenues(),
      ChatScreen(_venueName),
    ];

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
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Search for venues'),
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
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outlined), label: 'Chat'),
        ],
      ),
    );
  }
}
