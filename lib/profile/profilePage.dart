import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile/edit_profile.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/services/firestore.dart';
import 'package:flutter_application_1/services/models.dart';
import 'package:flutter_application_1/shared/background.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/edit_pass_auth.dart';

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
  var user = AuthService().user;
// Stream to retrieve therapist data
  late Stream<DocumentSnapshot> therapistStream = FirebaseFirestore.instance
      .collection('Therapist')
      .doc(user!.uid)
      .snapshots();

  void openedit_pass_auth() {
    Navigator.of(context).pushReplacementNamed('edit_pass_auth');
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('Therapist')
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot lastDocument = snapshot.docs.first;
        setState(() {
          therapistStream = FirebaseFirestore.instance
              .collection('Therapist')
              .doc(user!.uid)
              .snapshots();
        });
      }
    });
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
                              _fullnameController.text = therapistData.name;
                              _emailController.text = therapistData.email;
                              _jobController.text = therapistData.jobTitle;
                              _hospitalController.text =
                                  therapistData.hospitalClinic;
                            }
                          }
                          return Column(
                            children: [
                              TextFormField(
                                enabled: false,
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                controller: _emailController,
                                decoration: InputDecoration(
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
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                controller: _jobController,
                                decoration: InputDecoration(
                                  labelText: 'Job Title',
                                  hintText: 'Physical Therapist',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.work),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                enabled: false,
                                controller: _hospitalController,
                                decoration: InputDecoration(
                                  labelText: 'Hospital/Clinic',
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFF186257),
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.local_hospital),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('editprofilepage');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF186257)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text('Edit'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Do you want to change your password ? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => edit_pass_auth()),
                              );
                            },
                            child: Text(
                              'Change password',
                              style: TextStyle(
                                  color: Color(0xFF186257),
                                  fontFamily: 'Merriweather'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('signinScreen');
                          },
                          icon: Icon(
                            Icons.logout,
                            size: 30.0,
                            color: Color.fromARGB(255, 150, 150, 150),
                          ),
                          label: Text(
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
      bottomNavigationBar: NavBar(),
    );
  }
}

extension StringValidation on String {
  bool get isAlphaOnly => this.runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}
