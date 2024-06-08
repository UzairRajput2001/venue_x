import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/Admin/AddScreen.dart';
import 'package:venue_x/Admin/venues_screen.dart';

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    // String userEmail = user?.email ?? 'No user signed in';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'What do you want to do?',
                style: GoogleFonts.outfit(
                    textStyle: const TextStyle(fontSize: 25),
                    color: Colors.black),
              ),
              const SizedBox(height: 40),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  AddVenueScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      shadowColor: Color.fromRGBO(0, 0, 0, 0.694)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Add Venues',
                            style: TextStyle(
                                fontFamily: 'outfit',
                                fontSize: 20,
                                color: Colors.white)),
                        const Icon(
                          Icons.edit_note,
                          color: Colors.white,
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VenueScreen(
                                routeName: 'update',
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Update Venues',
                            style: TextStyle(
                                fontFamily: 'outfit',
                                fontSize: 20,
                                color: Colors.white)),
                        const Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const VenueScreen(routeName: "delete")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Delete Venues',
                          style: TextStyle(
                              fontFamily: 'outfit',
                              fontSize: 20,
                              color: Colors.white)),
                      const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
