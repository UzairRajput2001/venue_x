import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/Admin/adminhomepage.dart';
import 'package:venue_x/Screens/AdminRegistrationpage.dart';
import 'package:venue_x/Screens/Registration_page.dart';
import 'package:venue_x/User/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:venue_x/component/forgotpassword.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future<void> _login(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Check if the user is a venue owner
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
    DocumentSnapshot venueOwnerSnapshot = await FirebaseFirestore.instance.collection('venueOwners').doc(userCredential.user!.uid).get();
    bool isVenueOwner = venueOwnerSnapshot.exists;

    // Navigate based on user type
    if (isVenueOwner) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  } catch (e) {
    // Handle login errors
    print('Failed to login: $e');
    // Show a dialog for incorrect credentials
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Incorrect email or password. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    }
  } catch (e) {
    print('Failed to sign in with Google: $e');
  }
  return null;
}

    // Check if the user is a venue owner (you need to define a way to differentiate between regular users and venue owners)
    // For demonstration purposes, let's assume venue owners have an "isVenueOwner" field in their Firestore document
    

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Image(image: AssetImage('assets/images/logo.png'), height: 100, alignment: Alignment.center),
            ),
            Text(
              "Login to App",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                prefixIcon: const Icon(
                  Icons.mail_rounded,
                  color: Colors.black,
                ),
              ),
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                prefixIcon: const Icon(Icons.fingerprint_sharp),
                suffixIcon: const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye),
                ),
              ),
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const forgotpassword()),
                    );
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.deepPurpleAccent,
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                onPressed: () => _login(context),
                child: Text(
                  "Login",
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Text(
                "OR",
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // No sign in with Google button here
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                },
                child: Text.rich(
                  TextSpan(
                    text: "Don't Have an Account?",
                    style: GoogleFonts.outfit(),
                    children: const [
                      TextSpan(text: "Signup", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRegistrationPage()));
                },
                child: Text.rich(
                  TextSpan(
                    text: "Register as an Venue Owner !",
                    style: GoogleFonts.outfit(),
                    children: const [
                      TextSpan(text: "Register", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    ),
  );
}
}

