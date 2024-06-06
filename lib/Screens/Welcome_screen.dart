import 'package:flutter/material.dart';
// import 'package:untitled1/Screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/Screens/login_page.dart';
import 'package:venue_x/User/home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Image(image: AssetImage("assets/images/logo.png")),
            ),
            Text(
                'The Easy Way to Find Venue',
                style:GoogleFonts.poppins(fontSize: 50, fontWeight: FontWeight.bold)),
            
            Text('Find Venue in a Easy Way.',
            style: GoogleFonts.outfit(fontSize: 20)),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: Colors.purpleAccent),
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                    label: const Text('Get Started')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
