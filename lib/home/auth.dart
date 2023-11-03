import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_screen.dart';
//import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/signin/signin_form.dart';
// import 'package:flutter_application_1/signup_form.dart';
import 'package:flutter_application_1/services/authentic.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: AuthService().userStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error in connecting to firebase'),
            );
          } else {
            return const SignInForm();
          }
        }),
      ),
    );
  }
}
