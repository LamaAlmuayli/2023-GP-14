import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/services/authentic.dart';

class edit_pass_auth extends StatefulWidget {
  const edit_pass_auth({super.key});

  State<edit_pass_auth> createState() => _SignInState();
}

class _SignInState extends State<edit_pass_auth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var user = AuthService().user;
  late Stream<DocumentSnapshot> therapistStream = FirebaseFirestore.instance
      .collection('Therapist')
      .doc(user!.uid)
      .snapshots();

  Future next() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.of(context).pushNamed('changePass');

      // Registration successful
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'INVALID_CREDENTIALS') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The email or password is incorrect ')));
        } else {
          // Handle other FirebaseAuthException errors or display a generic error message.
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred: ${e.message}')));
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                                  'Enter your current password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Merriweather'),
                                ),
                              ),
                              SizedBox(height: 10),
                              StreamBuilder<DocumentSnapshot>(
                                stream: therapistStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    final therapistData = snapshot.data!.data();
                                    if (therapistData != null) {
                                      _emailController.text =
                                          therapistData is Map<String, dynamic>
                                              ? therapistData['Email']
                                              : '';
                                    }
                                  }
                                  return TextFormField(
                                    readOnly: true,
                                    initialValue: user!.email,
                                    decoration: InputDecoration(
                                      enabled: false,
                                      labelText: 'Email',
                                      hintText: 'xxxx@xxxxx.xx',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Color(0xFF186257),
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Password',
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
                              SizedBox(height: 20),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: GestureDetector(
                                      onTap: next,
                                      child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF186257),
                                            borderRadius: BorderRadius.circular(
                                                15), // Rounded borders
                                          ),
                                          child: Center(
                                              child: Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors.white,
                                              //fontFamily: 'Merriweather', // White text color
                                            ),
                                          ))))),
                              SizedBox(height: 10),
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
