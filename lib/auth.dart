import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/signin_form.dart';
import 'package:flutter_application_1/signup_form.dart';


class Auth extends StatelessWidget{ 
   Auth({super.key}); 

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) { 
        if (snapshot.hasData) { 
          return HomeScreen(); 
        } else {
          return SignInForm(); 
        }
        

      }),
    

    ),
    );

   } }







