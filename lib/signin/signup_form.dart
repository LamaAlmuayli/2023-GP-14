//import 'dart:html';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/authentic.dart';
import '../shared/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpState();
}

String hashPassword(String password, String salt) {
  final key = utf8.encode(salt);
  final bytes = utf8.encode(password);
  final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  final digest = hmacSha256.convert(bytes);
  return digest.toString();
}

class _SignUpState extends State<SignUpForm> {
  String hashedPassword = hashPassword('user_password', 'unique_salt');
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _jobController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cnfpasswordController = TextEditingController();
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = AuthService().user;

  Future signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      Map<String, String> dataToSave = {
        'Full name': _fullnameController.text,
        'Email': _emailController.text,
        'Job Title': _jobController.text,
        'HospitalClinic': _hospitalController.text,
        'Password': hashedPassword,
      };

      await FirebaseFirestore.instance
          .collection('Therapist')
          .doc(uid)
          .set(dataToSave);

      Navigator.of(context).pushNamed('homepage');
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Handle FirebaseAuthException errors
      }
    }

    Map<String, String> dataToSave = {
      'Full name': _fullnameController.text,
      'Email': _emailController.text,
      'Job Title': _jobController.text,
      'Hospital/Clinic': _hospitalController.text,
      'Password': hashedPassword,
    };

//Check if any of the fields are empty
    bool allFieldsNotEmpty = true;

    dataToSave.forEach((key, value) {
      if (value.isEmpty) {
        allFieldsNotEmpty = false;
        //emptyField = key;
      }
    });

    if (allFieldsNotEmpty) {
      FirebaseFirestore.instance.collection('Therapist').add(dataToSave);
      // All fields are not empty, proceed with adding the patient.
      // Add your code to save the patient data here.
    } else {
      // Display an error message
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Please fill out the fields.'),
        ),
      );
    }

    //Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage));
  }

  // }
//}

/*bool passwordConfirmed() { 
  if (_passwordController.text.trim() == 
  _cnfpasswordController.text.trim()) { 
    return true; 
  } else { 
    "password doesnot match"; 
   return false; 
  }
}*/
  void openSignInScreen() {
    Navigator.of(context).pushReplacementNamed('signinScreen');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cnfpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Stack(
          children: [
            const Background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                color: const Color(0xFF186257),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'Sign up for an account',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _fullnameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257), // Blue border in hex
                              ),
                            ),
                            prefixIcon: const Icon(
                                Icons.person), // Icon for date of birth
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full name is required';
                            } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                .hasMatch(value)) {
                              return 'Full name should only contain alphabetic characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'xxxx@xxxxx.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257), // Blue border in hex
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.email), // Icon for email
                          ),
                          // validator: validateEmail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!EmailValidator.validate(value) ||
                                RegExp(r'^[A-Za-z][A-Za-z0-9]*$')
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            } else {
                              // You should add logic to check if the email is already in the database here.
                              // If it is repeated, return an error message.
                              // For now, return null as a placeholder.
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _jobController,
                            decoration: InputDecoration(
                              labelText: 'Job Title',
                              hintText: 'Physical Therapist',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color:
                                      Color(0xFF186257), // Blue border in hex
                                ),
                              ),
                              prefixIcon: const Icon(Icons.work), // Icon
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Job Title is required';
                              } else if (!value.isAlphaOnly) {
                                return 'Job Title should only contain alphabetic characters';
                              }
                              return null;
                            }),
                        const SizedBox(height: 10),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _hospitalController,
                            decoration: InputDecoration(
                              labelText: 'Hospital/Clinic',
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color:
                                      Color(0xFF186257), // Blue border in hex
                                ),
                              ),
                              prefixIcon:
                                  const Icon(Icons.local_hospital), // Icon
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Hospital/Clinic is required';
                              } else if (!value.isAlphaOnly) {
                                return 'Hospital/Clinic should only contain alphabetic characters';
                              }
                              return null;
                            }),
                        const SizedBox(height: 10),

                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257), // Blue border in hex
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock), // Icon for password
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
                        const SizedBox(height: 10),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          controller: _cnfpasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257), // Blue border in hex
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock), // Icon for password
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
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: signUp,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF186257),
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded borders
                              ),
                              child: const Center(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        'Merriweather', // White text color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //ElevatedButton(
                        // onPressed: signUp, // Call the signUp function when the button is pressed
                        //style: ButtonStyle(
                        // backgroundColor: MaterialStateProperty.all(Color(0xFF186257)),
                        // ),
                        // child: Text('Sign Up'),
                        // ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an acount? "),
                            GestureDetector(
                              onTap: openSignInScreen,
                              child: const Text(
                                'Sign In here',
                                style: TextStyle(
                                  color:
                                      Color(0xFF186257), // Green color in hex
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ],
      ),
    );
    //);
  }
}

extension StringValidation on String {
  bool get isAlphaOnly => runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}
