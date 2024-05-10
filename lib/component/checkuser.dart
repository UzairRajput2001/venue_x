import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/User/home_page.dart';
import 'package:venue_x/Screens/login_page.dart';

class _CheckUser extends StatefulWidget {
  const _CheckUser();

  @override
  State<_CheckUser> createState() => __CheckUserState();
}

class __CheckUserState extends State<_CheckUser> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

checkuser(){
  final user = FirebaseAuth.instance.currentUser;
  if (user != null){
    return const HomePage();
}
else{
   return LoginPage();
  }
}