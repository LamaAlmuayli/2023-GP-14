import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'dart:convert';
// import 'package:crypto/crypto.dart';

class changePass extends StatefulWidget {
  const changePass({super.key});

  State<changePass> createState() => _SignInState();
}

// String hashPassword(String password, String salt) {
//   final key = utf8.encode(salt);
//   final bytes = utf8.encode(password);
//   final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
//   final digest = hmacSha256.convert(bytes);
//   return digest.toString();
// }

class _SignInState extends State<changePass> {
  // String hashedPassword = hashPassword('user_password', 'unique_salt');
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _cnfpasswordController = TextEditingController();

  // Future Confirm() async {
  //   final CollectionReference collection =
  //       FirebaseFirestore.instance.collection('Therapist');
  //   final DocumentReference document = collection.doc('C3oGSdDhrzf3CcadYajv');

// Fetch the existing document
  // final DocumentSnapshot snapshot = await document.get();

  // if (snapshot.exists) {
  //   // Get the existing data as a Map
  //   Map<String, dynamic> existingData =
  //       snapshot.data() as Map<String, dynamic>;

  //   // Remove the fields you want to "delete"
  //   existingData.remove('Password');

  //   // Add the fields with new values
  //   existingData['Password'] =
  //       _passwordController.text; // change it to hashedPassword

  //   // Update the document with the modified data
  //   await document.set(existingData);
  // }

  Future changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await user!.updatePassword(newPassword);
      print("Password updated successfully");
      Navigator.of(context).pushNamed('profilepage');
    } catch (e) {
      print("Failed to update password: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _cnfpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF186257),
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              Container(
                color: Color(0xFF186257),
                child: Image.asset(
                  "assets/images/background.jpeg",
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  'Enter new password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Merriweather'),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                controller: _cnfpasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  } else if (_cnfpasswordController.text !=
                                      _passwordController.text) {
                                    return 'Password doesnot match';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: GestureDetector(
                                      onTap: () {
                                        changePassword(_passwordController
                                            .text); // Call changePassword asynchronously
                                      },
                                      //  Confirm,
                                      child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF186257),
                                            borderRadius: BorderRadius.circular(
                                                15), // Rounded borders
                                          ),
                                          child: Center(
                                              child: Text(
                                            'Confirm',
                                            style: TextStyle(
                                              color: Colors.white,
                                              //fontFamily: 'Merriweather', // White text color
                                            ),
                                          ))))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
