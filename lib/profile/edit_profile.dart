import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/services/firestore.dart';
import 'package:flutter_application_1/services/models.dart';
import 'package:flutter_application_1/shared/background.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';

class editprofile extends StatefulWidget {
  const editprofile({super.key});

  @override
  State<editprofile> createState() => _SignUpState();
}

class _SignUpState extends State<editprofile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for UI display
  final _displayFullnameController = TextEditingController();
  final _displayEmailController = TextEditingController();
  final _displayJobController = TextEditingController();
  final _displayHospitalController = TextEditingController();

  // Controllers for database storage
  final _storeFullnameController = TextEditingController();
  final _storeEmailController = TextEditingController();
  final _storeJobController = TextEditingController();
  final _storeHospitalController = TextEditingController();
  var user = AuthService().user;
  late Stream<DocumentSnapshot> therapistStream = FirebaseFirestore.instance
      .collection('Therapist')
      .doc(user!.uid)
      .snapshots();

  // void openedit_pass_auth() {
  // Navigator.of(context).pushReplacementNamed('edit_pass_auth');
  // }

  @override
  void initState() {
    super.initState();

    // Initialize StreamBuilder with controllers for UI display
    therapistStream = FirebaseFirestore.instance
        .collection('Therapist')
        .doc('JzhiqlmRT8qd3IX65cGr')
        .snapshots();

    // Add listener to update UI controllers
    _storeFullnameController.addListener(() {
      _displayFullnameController.text = _storeFullnameController.text;
    });

    _storeEmailController.addListener(() {
      _displayEmailController.text = _storeEmailController.text;
    });

    _storeJobController.addListener(() {
      _displayJobController.text = _storeJobController.text;
    });

    _storeHospitalController.addListener(() {
      _displayHospitalController.text = _storeHospitalController.text;
    });
  }

  Future<void> saveTherapistData() async {
    // Map<String, String> dataToSave = {
    //   'Full name': _displayFullnameController.text,
    //   'Email': _displayEmailController.text,
    //   'Hospital/Clinic': _displayHospitalController.text,
    //   'Job Title': _displayJobController.text,
    // };
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Therapist');
    final DocumentReference document = collection.doc(user!.uid);

// Fetch the existing document
    final DocumentSnapshot snapshot = await document.get();

    if (snapshot.exists) {
      // Get the existing data as a Map
      Map<String, dynamic> existingData =
          snapshot.data() as Map<String, dynamic>;

      // Remove the fields you want to "delete"
      existingData.remove('Full name');
      existingData.remove('Email');
      existingData.remove('HospitalClinic');
      existingData.remove('Job Title');

      // Add the fields with new values
      existingData['Full name'] = _displayFullnameController.text;
      existingData['Email'] = _displayEmailController.text;
      existingData['HospitalClinic'] = _displayHospitalController.text;
      existingData['Job Title'] = _displayJobController.text;

      // Update the document with the modified data
      await document.set(existingData);
      Navigator.of(context).pushReplacementNamed('edit_pass_auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              color: Color(0xFF186257),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.6,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Profile information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<Therapist>(
                          stream: FirestoreService().streamTherapist(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              final therapistData = snapshot.data!;
                              if (therapistData != null) {
                                _storeFullnameController.text =
                                    therapistData.name;
                                _storeEmailController.text =
                                    therapistData.email;
                                _storeJobController.text =
                                    therapistData.jobTitle;
                                _storeHospitalController.text =
                                    therapistData.hospitalClinic;
                              }
                            }
                            return Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayFullnameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    hintText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xFF186257),
                                      ),
                                    ),
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
                                SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayEmailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'xxxx@xxxxx.xx',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xFF186257),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    } else if (!EmailValidator.validate(
                                            value) ||
                                        RegExp(r'^[A-Za-z][A-Za-z0-9]*$')
                                            .hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _displayJobController,
                                    decoration: InputDecoration(
                                      labelText: 'Job Title',
                                      hintText: 'Physical Therapist',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Color(0xFF186257),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Job Title is required';
                                      } else if (!value.isAlphaOnly) {
                                        return 'Job Title should only contain alphabetic characters';
                                      }
                                      return null;
                                    }),
                                SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayHospitalController,
                                  decoration: InputDecoration(
                                    labelText: 'Hospital/Clinic',
                                    hintText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xFF186257),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Hospital/Clinic is required';
                                    } else if (!value.isAlphaOnly) {
                                      return 'Hospital/Clinic should only contain alphabetic characters';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveTherapistData();
                              Navigator.pop(context);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF186257)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

extension StringValidation on String {
  bool get isAlphaOnly => this.runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}
