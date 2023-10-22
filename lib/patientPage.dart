import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientPage extends StatelessWidget {
  Future<DocumentSnapshot<Map<String, dynamic>>> getPatientInfo() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Patient').doc('P01').get();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getPatientInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Return a loader while data is being fetched.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> patientData = snapshot.data!.data()!;
          int? patientID = patientData['ID'] as int?;
          String? patientName = patientData['Name'] as String?;
          int? patientPhone = patientData['Phonenumber'] as int?;
          String? patientEmail = patientData['Email'] as String?;

          if (patientID != null &&
              patientName != null &&
              patientPhone != null &&
              patientEmail != null) {
            int patientID = patientData['ID'];
            String patientName = patientData['Name'];
            int patientPhone = patientData['Phonenumber'];
            String patientEmail = patientData['Email'];
          }

          double boxWidth = MediaQuery.of(context).size.width - 50.0;

          return Scaffold(
            // appBar: AppBar(
            //   title: Text('Patient Page'),
            // ),
            body: Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          "$patientName",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF186257),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.message),
                                      title: Text('Send SMS'),
                                      onTap: () async {
                                        final phoneNumber = '+966$patientPhone';
                                        final url = 'sms:$phoneNumber';

                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.email),
                                      title: Text('Send Email'),
                                      onTap: () async {
                                        final email = '$patientEmail';
                                        final url = 'mailto:$email';

                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.phone),
                                      title: Text('WhatsApp'),
                                      onTap: () async {
                                        final phoneNumber = '+966$patientPhone';
                                        final url =
                                            'https://api.whatsapp.com/send?phone=$phoneNumber';

                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Image.asset(
                              'images/contact.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: boxWidth,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F3F5),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 55),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Patient Number: $patientID',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Phone: $patientPhone',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Email: $patientEmail',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: boxWidth,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 5.0, right: 16.0),
                                child: Text(
                                  "Patient's Information",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'images/edit.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF186257),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: boxWidth, // Set the box width
                          height: 180,
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F3F5),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 18.0), // Adjust the value as needed
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'No program added yet',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF7A7A7A),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: boxWidth, // Set the box width
                          height: 45, // 0.2 of the height of the big box
                          child: Row(
                            // Added Row widget
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Aligns items to the start and end of the row
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    top: 5.0,
                                    right: 16.0), // Adjusted padding
                                child: Text(
                                  "Patient's Program", // Added text here
                                  style: TextStyle(
                                    fontSize: 20, // Adjusted font size
                                    color:
                                        Colors.white, // Set text color to black
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(
                                    10.0), // Adjust padding as needed
                                child: Image.asset(
                                  // Added Image widget for the icon
                                  'images/add.png',
                                  height: 20, // Adjust icon size as needed
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF186257), // Color 186257
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'History of generated reports',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF186257), // Set text color to black
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Align(
                    alignment: Alignment.topCenter, // Center align the text
                    child: Text(
                      'No reports yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7A7A7A), // Color 7A7A7A
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: NavBar(),
          );
        }
      },
    );
  }
}
