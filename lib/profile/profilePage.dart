import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';
import '../shared/background.dart';
import 'package:firebase_auth/firebase_auth.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _SignUpState();
}

class _SignUpState extends State<profile> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _jobController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cnfpasswordController = TextEditingController();

// Stream to retrieve therapist data
  late Stream<DocumentSnapshot> therapistStream;
  @override
  void initState() {
    super.initState();
    // Initialize the stream to get the last document added
    FirebaseFirestore.instance
        .collection('Therapist')
        .orderBy(FieldPath.documentId,
            descending: true) // Order by document ID in descending order
        .limit(
            1) // Limit the query to 1 result, which is the last added document
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Do something with the last document
        DocumentSnapshot lastDocument = snapshot.docs.first;
        setState(() {
          therapistStream = FirebaseFirestore.instance
              .collection('Therapist')
              .doc(lastDocument.id) // Get the document by its ID
              .snapshots();
        });
      }
    });
  }

  Future signUp() async {
    // If everything is valid, proceed with the sign-up.
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Navigator.of(context).pushNamed('/');

    Map<String, String> dataToSave = {
      'Full name': _fullnameController.text,
      'Email': _emailController.text,
      'Job Title': _jobController.text,
      'Hospital/Clinic': _hospitalController.text,
      'Password': _passwordController.text,
    };

    FirebaseFirestore.instance.collection('Therapist').add(dataToSave);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cnfpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'Profile information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Use StreamBuilder to populate form fields
                      StreamBuilder<DocumentSnapshot>(
                        stream: therapistStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            final therapistData = snapshot.data!.data();
                            if (therapistData != null) {
                              // Populate form fields
                              _fullnameController.text =
                                  therapistData is Map<String, dynamic>
                                      ? therapistData['Full name']
                                      : '';
                              _emailController.text =
                                  therapistData is Map<String, dynamic>
                                      ? therapistData['Email']
                                      : '';
                              _jobController.text =
                                  therapistData is Map<String, dynamic>
                                      ? therapistData['Job Title']
                                      : '';
                              _hospitalController.text =
                                  therapistData is Map<String, dynamic>
                                      ? therapistData['Hospital/Clinic']
                                      : '';
                            }
                          }
                          return Column(
                            children: [
                              TextFormField(
                                enabled: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Full name is required';
                                  } else if (!value.isAlphaOnly) {
                                    return 'Full name should only contain alphabetic characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'xxxx@xxxxx.xx',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  } else if (!EmailValidator.validate(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              // Other form fields here
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _jobController,
                                decoration: InputDecoration(
                                  labelText: 'Job Title',
                                  hintText: 'Physical Therapist',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.work),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Job Title is required';
                                  } else if (!value.isAlphaOnly) {
                                    return 'Job Title should only contain alphabetic characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _hospitalController,
                                decoration: InputDecoration(
                                  labelText: 'Hospital/Clinic',
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.local_hospital),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Hospital/Clinic is required';
                                  }
                                  return null;
                                },
                              ),
                              // Rest of the form fields
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (() => Navigator.of(context).pushNamed(
                            'editprofilepage')), // Call the signUp function when the button is pressed
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xFF186257)),
                        ),
                        child: const Text('Edit'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          onPressed: () {
                            //FirebaseAuth.instance.signOut();

                            Navigator.of(context).pushNamed('signinScreen');
                          },
                          icon: const Icon(
                            Icons.logout,
                            size: 30.0,
                            color: Color.fromARGB(255, 150, 150, 150),
                          ),
                          label: const Text(
                            'Log out',
                            style: TextStyle(
                                color: Color.fromARGB(255, 150, 150, 150),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Merriweather'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

extension StringValidation on String {
  bool get isAlphaOnly => runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}
