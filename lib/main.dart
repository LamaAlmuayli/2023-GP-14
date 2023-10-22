import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/PatientPage.dart';
import 'package:flutter_application_1/auth.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/profilePage.dart';
import 'package:flutter_application_1/signin_form.dart';
import 'package:flutter_application_1/signup_form.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/AddPatient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/splash_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "TheraSense",
      options: FirebaseOptions(
        apiKey: "AIzaSyAyaW86iJF-2Zh0n0aukpgzK7Z9ff5jaPs",
        appId: "Y1:621591419878:android:401900529264c1499c1427",
        messagingSenderId: "621591419878",
        projectId: "therasense-391bb",
      ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: profile(),
      routes: {
        '/': (context) => HomePage(),
        'Auth': (context) => Auth(),
        'signupScreen': (context) => SignUpForm(),
        'signinScreen': (context) => SignInForm(),
        'AddpatientScreen': (context) => AddPatient(),
        'homepage': (context) => homePage(),
        'profilepage': (context) => profile(),
        'patientpage': (context) => PatientPage(),
      },
      theme: ThemeData(
        primaryColor: Color(0xFF186257),
      ),
    );
  }
}


// Update the signInWithFirebase function to accept user input for email and password
/*Future<User?> signInWithFirebase(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}*/
