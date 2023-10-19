import 'package:flutter/material.dart';
import 'package:flutter_application_1/background.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final _formKey = GlobalKey<FormState>();
  late DateTime selectedDate;
  final _patientnameController = TextEditingController();
  final _idController = TextEditingController();
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
 

  Future Addpatient() async {
    Map<String, String> dataToSave = {
      'Patient Name': _patientnameController.text,
      'ID': _idController.text,
      'Date of Birth': _dateController.text,
      'Phone Number': _phoneController.text,
      'Email': _emailController.text,
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
      QuickAlert.show(
          context: context,
          text: "The Patient is in your list now!",
          type: QuickAlertType.success);
      FirebaseFirestore.instance.collection('Patient').add(dataToSave);
      // All fields are not empty, proceed with adding the patient.
      // Add your code to save the patient data here.
    } else {
      // Display an error message
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Please fill out the fields.'),
        ),
      );
    }

    //Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage));
  }
  // TextEditingController _dateController = TextEditingController();
  //late DateTime selectedDate;

  //Future<void> _selectDate(BuildContext context) async {
  // final DateTime? picked = await showDatePicker(
  //  context: context,
  // initialDate: selectedDate ?? DateTime.now(),
  //  firstDate: DateTime(1900),
  // lastDate: DateTime(2101),
  // );

  //if (picked != null && picked != selectedDate) {
  //setState(() {
  //  selectedDate = picked;
  // _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
  // });
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Stack(
          children: [
            Background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height /
                    2, // Half of the screen
                color: Color.fromRGBO(24, 98, 87, 1),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter, // Align the form to the bottom
              child: FractionallySizedBox(
                heightFactor:
                    0.6, // Adjust this value as needed to control the form height
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
                            'Add a patient',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _patientnameController,
                            decoration: InputDecoration(
                              labelText: 'Patient Name',
                              hintText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF186257), // Blue border in hex ( i will fix it)
                                ),
                              ),
                              prefixIcon: Icon(Icons.person), // Person icon
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full name is required';
                              } else if (!value.isAlphaOnly) {
                                return 'Full name should only contain alphabetic characters';
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _idController,
                            decoration: InputDecoration(
                              labelText: 'ID',
                              hintText: 'XXXXX',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF186257), // Blue border in hex ( i will fix it)
                                ),
                              ),
                              prefixIcon: Icon(Icons.person), // Person icon
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ID is required';
                              } else if (!value.contains(RegExp(r'^[0-9]+$'))) {
                                return 'Please enter digits only';
                              } else if (value.length > 5) {
                                return 'ID must be at most 5 digits';
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: '05XXXXXXXX',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(
                                      0xFF186257), // Blue border in hex ( i will fix it)
                                ),
                              ),
                              prefixIcon: Icon(Icons.phone), // Person icon
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone Number is required';
                              } else if (!RegExp(r'^05[0-9]+$')
                                  .hasMatch(value)) {
                                if (!RegExp(r'^05').hasMatch(value)) {
                                  return 'Please start your number with \'05\'';
                                } else {
                                  return 'Please enter digits only';
                                }
                              } else if (value.length > 10) {
                                return 'Phone number must be 10 digits';
                              }
                              return null;
                            }),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _dateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF186257), // Blue border in hex
                              ),
                            ),
                            prefixIcon: Icon(Icons.calendar_today),
                            // Calendar icon
                          ),
                          onTap: () async {
                            final DateTime currentDate = DateTime.now();
                            DateTime? pickeddate = await showDatePicker(
                                context: context,
                                initialDate: currentDate,
                                firstDate: DateTime(1900),
                                lastDate: currentDate);
                            if (pickeddate != null) {
                              setState(() {
                                _dateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickeddate);
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Adress',
                              hintText: 'xxxx@xxxxx.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color:
                                      Color(0xFF186257), // Blue border in hex
                                ),
                              ),
                              prefixIcon: Icon(Icons.email), // Email icon
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
                            }),
                      
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: Addpatient,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF186257),
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded borders
                              ),
                              child: Center(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white, // White text color
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

            // Back arrow icon
            Positioned(
              top: 20, // Adjust the position as needed
              left: 10, // Adjust the position as needed
              child: IconButton(
                icon: Icon(
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

extension StringValidation on String {
  bool get isAlphaOnly => this.runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}
