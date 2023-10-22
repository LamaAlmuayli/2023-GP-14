import 'package:flutter/material.dart';
import 'package:flutter_application_1/PatientPage.dart';
import 'nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class homePage extends StatelessWidget {
  Stream<QuerySnapshot<Map<String, dynamic>>> getPatients() {
    return FirebaseFirestore.instance.collection('Patient').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      //   backgroundColor: Color(0xFF186257),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'images/welcome_icon.png',
                  height: 24,
                  width: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              'Dr. Ahmed',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Merriweather',
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xD9D9D9).withOpacity(0.7),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Recent Articles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF186257),
                fontFamily: 'Merriweather',
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Container(
                      width: 340,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mental health on SPI patients',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Publisher: Dr. Ahmed Alghamdi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Number of Reads: 244',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Date: 2023-10-16',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patients',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF186257),
                    fontFamily: 'Merriweather',
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle the selected option here
                    if (value == 'lowestRank') {
                      // Filter patients by lowest rank
                    } else if (value == 'highestRank') {
                      // Filter patients by highest rank
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Filter by lowest rank', 'Filter by highest rank'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice == 'Filter by lowest rank'
                            ? 'lowestRank'
                            : 'highestRank',
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      'images/filter.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: 800,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getPatients(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var patients = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          var patientName =
                              patients[index].data()['Name']?.toString();
                          var patientNumber =
                              patients[index].data()['ID']?.toString();
                          if (patientName != null &&
                              patientName != 'No Name Available' &&
                              patientNumber != null) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientPage(),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Container(
                                  height: 130,
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patientName,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Merriweather',
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'patient#' + patientNumber,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox
                                .shrink(); // Return an empty widget if name is not available
                          }
                        },
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text('Error loading data'),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('AddpatientScreen');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF186257),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavBar(),
    );
  }
}
