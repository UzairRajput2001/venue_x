import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_x/Screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  Future<void> _RegisterVenueOwner(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Add venue owner data to Firestore
    await FirebaseFirestore.instance.collection('venueOwners').doc(userCredential.user!.uid).set({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneNumberController.text,
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Your account has been created successfully.'),
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
  } catch (e) {
    // Handle registration errors
    print('Failed to register venue owner: $e');
    // Show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Failed to create your account. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Image(image: AssetImage('assets/images/logo.png'), height: 100, alignment: Alignment.center),
              ),
              Text(
                "Register to App",
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Name of the Venue",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Venue Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.mail_rounded),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Venue Phone Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
  controller: _passwordController,
  obscureText: !_isPasswordVisible,
  decoration: InputDecoration(
    hintText: "Password",
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    prefixIcon: const Icon(Icons.lock),
    suffixIcon: IconButton(
      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    ),
  ),
),

              const SizedBox(height: 20.0),
              SizedBox(
                
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.deepPurpleAccent,
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () => _RegisterVenueOwner(context),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                child: const Text.rich(
                            TextSpan(
                              text: "Already Have an Account?",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: "Log in",
                                    style: TextStyle(color: Colors.blue))
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
