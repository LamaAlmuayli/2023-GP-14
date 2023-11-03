import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/bottom_nav.dart';
//import 'package:flutter_application_1/patient/patientPage.dart';
import '../shared/nav_bar.dart';
import '../services/models.dart';
import '../services/firestore.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  // Stream<QuerySnapshot<Map<String, dynamic>>> getPatients() {
  //   return FirebaseFirestore.instance.collection('Patient').snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(width: 8),
                const Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Text(
              'Dr. Ahmed',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Merriweather',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0x00d9d9d9).withOpacity(0.7),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Articles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF186257),
                fontFamily: 'Merriweather',
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
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
                      padding: const EdgeInsets.all(16),
                      child: const Column(
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
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
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
                    padding: const EdgeInsets.all(8),
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
              child: StreamBuilder<Patient>(
                stream: FirestoreService().streamPatient('98765'),
                builder:
                    (BuildContext context, AsyncSnapshot<Patient> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  Patient? patient = snapshot.data;

                  if (patient != null) {
                    return Text(patient
                        .name); // Assuming 'name' is a property of the Patient class
                  } else {
                    return Text('Patient not found');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('AddpatientScreen');
        },
        backgroundColor: const Color(0xFF186257),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const NavBar(),
    );
  }
}
