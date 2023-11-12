// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/auth.dart';
import 'package:flutter_application_1/shared/background.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';
import 'package:quickalert/quickalert.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  late DateTime selectedDate;
  final _patientnameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String selectedGender = '';

  Future<void> Addpatient() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      var user = AuthService().user;

      if (user == null) {
        return;
      }

      // Check if any of the fields are empty
      if (_patientnameController.text.isEmpty ||
          _idController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _emailController.text.isEmpty) {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Please fill out all the fields.'),
          ),
        );
        return;
      }

      // Check if the provided ID already exists in the database
      bool idExists = await checkIfIdExists(_idController.text);

      if (idExists) {
        QuickAlert.show(
          context: context,
          text: "Patient number already exists!",
          type: QuickAlertType.error,
        );
      } else {
        Map<String, String> dataToSave = {
          'Patient Name': _patientnameController.text,
          'Patient Number': _idController.text,
          'Phone Number': _phoneController.text,
          'Email': _emailController.text,
          'TheraID': user.uid,
          'Gender': selectedGender,
        };

        await FirebaseFirestore.instance
            .collection('Patient')
            .doc(_idController.text)
            .set(dataToSave);

        QuickAlert.show(
          context: context,
          text: "The Patient is in your list now!",
          type: QuickAlertType.success,
        );

        Navigator.pushNamed(context, 'homepage');

        // Clear the form fields
        _patientnameController.clear();
        _idController.clear();

        _phoneController.clear();
        _emailController.clear();
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<bool> checkIfIdExists(String id) async {
    final query = await FirebaseFirestore.instance
        .collection('Patient')
        .where('ID', isEqualTo: id)
        .get();
    return query.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        body: Stack(
          children: [
            const Background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                color: const Color.fromRGBO(24, 98, 87, 1),
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
                            'Add a patient',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Merriweather'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _patientnameController,
                          decoration: InputDecoration(
                            labelText: 'Patient Name',
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.person),
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
                          controller: _idController,
                          decoration: InputDecoration(
                            labelText: 'Patient number',
                            hintText: 'XXXXX',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Patient number is required';
                            } else if (!value.contains(RegExp(r'^[0-9]+$'))) {
                              return 'Please enter digits only';
                            } else if (value.length > 5) {
                              return 'Patient number must be at most 5 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '05XXXXXXXX',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF186257),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone Number is required';
                            } else if (!RegExp(r'^05[0-9]+$').hasMatch(value)) {
                              if (!RegExp(r'^05').hasMatch(value)) {
                                return 'Please start your number with \'05\'';
                              } else {
                                return 'Please enter digits only';
                              }
                            } else if (value.length > 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'xxxx@xxxxx.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
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
                            // You should add logic to check if the email is already in the database here.
                            // If it is repeated, return an error message.
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text('Gender',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black87)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RadioListTile(
                                    title: Text('Female'),
                                    value: 'F',
                                    groupValue: selectedGender,
                                    activeColor: Color(0xFF186257),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile(
                                    title: Text('Male'),
                                    value: 'M',
                                    groupValue: selectedGender,
                                    activeColor: Color(0xFF186257),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    }),
                              )
                            ]),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: Addpatient,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF186257),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: _isSubmitting
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        'Add',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Merriweather',
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Color(0xFFFFFFFF),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
