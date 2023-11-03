import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
    child : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children : [
        const Text('Hello, You are signed in') ,
        MaterialButton(onPressed: () {FirebaseAuth.instance.signOut();} , 
        color:  const Color(0xFF186257), 
        child: const Text('sign out'),
         ),
      ],
   
    ),

    ),


    );
  }
}