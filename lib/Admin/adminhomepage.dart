import 'package:flutter/material.dart';
import 'package:venue_x/Admin/AdminChatScreen.dart';
import 'package:venue_x/Admin/AdminHomeScreen.dart';
import 'package:venue_x/Admin/AdminProfile.dart';
import 'package:venue_x/component/AdminMenu.dart';
// import 'package:untitled1/Screens/AdminChatScreen.dart';
// import 'package:untitled1/Screens/AdminHomeScreen.dart';
// import 'package:untitled1/Screens/AdminProfile.dart';
// import 'package:untitled1/component/AdminMenu.dart';
// import 'package:untitled1/component/drawer.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override

  State<AdminHome> createState() => _AdminHomeState();
}
class _AdminHomeState extends State<AdminHome>{

  int _currentIndex = 1;
  late List<Widget> body;

  @override
  Widget build(BuildContext context) {
    body = [
      const AdminProfileScreen(),
      const OwnerHomePage(),
      const AdminChatScreen(),
    ];
    return Scaffold(
      drawer: AdminNavBar(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: const <Widget>[
          
          
        ],
        backgroundColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
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
