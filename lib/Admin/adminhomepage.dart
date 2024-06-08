import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/Admin/AdminChatScreen.dart';
import 'package:venue_x/Admin/AdminHomeScreen.dart';
import 'package:venue_x/Admin/AdminProfile.dart';
import 'package:venue_x/Admin/adminActiveChats.dart';
import 'package:venue_x/component/AdminMenu.dart';

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
      const AdminActiveBookingScreen(),
    ];
    return Scaffold(
      drawer: AdminNavBar(),
      appBar: AppBar(
        title: const Text('Home',style:TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),

        backgroundColor: Colors.indigoAccent,
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
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        ],
      ),
    );
  }
}
