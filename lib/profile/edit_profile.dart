import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shared/nav_bar.dart';

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

  late Stream<DocumentSnapshot> therapistStream;

  @override
  void initState() {
    super.initState();

    // Initialize StreamBuilder with controllers for UI display
    therapistStream = FirebaseFirestore.instance
        .collection('Therapist')
        .doc('d2qJez1joy6pEsckWrJg')
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
    Map<String, String> dataToSave = {
      'Full name': _storeFullnameController.text,
      'Email': _storeEmailController.text,
      'Job Title': _storeJobController.text,
      'Hospital/Clinic': _storeHospitalController.text,
    };

    await FirebaseFirestore.instance
        .collection('Therapist')
        .doc('d2qJez1joy6pEsckWrJg')
        .update(dataToSave);
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
                  child: Form(
                    key: _formKey,
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
                        StreamBuilder<DocumentSnapshot>(
                          stream: therapistStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              final therapistData = snapshot.data!.data();
                              if (therapistData != null) {
                                _storeFullnameController.text =
                                    therapistData is Map<String, dynamic>
                                        ? therapistData['Full name']
                                        : '';
                                _storeEmailController.text =
                                    therapistData is Map<String, dynamic>
                                        ? therapistData['Email']
                                        : '';
                                _storeJobController.text =
                                    therapistData is Map<String, dynamic>
                                        ? therapistData['Job Title']
                                        : '';
                                _storeHospitalController.text =
                                    therapistData is Map<String, dynamic>
                                        ? therapistData['Hospital/Clinic']
                                        : '';
                              }
                            }
                            return Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayFullnameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Full Name',
                                    hintText: '',
                                    // Rest of your TextFormField properties
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayEmailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'xxxx@xxxxx.xx',
                                    // Rest of your TextFormField properties
                                  ),
                                ),
                                // Other form fields here
                                const SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayJobController,
                                  decoration: const InputDecoration(
                                    labelText: 'Job Title',
                                    hintText: 'Physical Therapist',
                                    // Rest of your TextFormField properties
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _displayHospitalController,
                                  decoration: const InputDecoration(
                                    labelText: 'Hospital/Clinic',
                                    hintText: '',
                                    // Rest of your TextFormField properties
                                  ),
                                ),
                                // Rest of the form fields
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveTherapistData();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(const Color(0xFF186257)),
                          ),
                          child: const Text('Save'),
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
      bottomNavigationBar: const NavBar(),
    );
  }
}
// Extension and Background classes remain the same

extension StringValidation on String {
  bool get isAlphaOnly => runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // Your background widget code here
        );
  }
}
