// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/View_article.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:intl/intl.dart';
import '../shared/nav_bar.dart';
import '../services/models.dart';
import '../services/firestore.dart';
import '../patient/patientPage.dart';

class communityTwo extends StatefulWidget {
  const communityTwo({Key? key}) : super(key: key);

  @override
  State<communityTwo> createState() => _communityTwoState();
}

class _communityTwoState extends State<communityTwo>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      backgroundColor: Color(0xFF186257),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('Write_article');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF186257),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<Therapist>(
                      stream: FirestoreService().streamTherapist(),
                      builder: (context, snapshot) {
                        String n = snapshot.data!.name;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi $n!👋',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${DateTime.now().day} ${_getMonth(DateTime.now().month)}, ${DateTime.now().year}',
                              style: TextStyle(
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: Color.fromARGB(255, 29, 116, 106),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.all(30),
                  height: 4000,
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'community'),
                          Tab(text: 'my articles'),
                          Tab(text: 'favorite'),
                        ],
                        labelColor: Color(0xFF186257),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        indicatorColor: Colors.black,
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: double.maxFinite,
                        height: 3500,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            StreamBuilder<List<Article>>(
                              stream: FirestoreService().streamArticles(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                List<Article> cards = snapshot.data ?? [];

                                List<Article> filteredCards = cards
                                    .where((article) =>
                                        article.Title.toLowerCase().contains(
                                            searchQuery.toLowerCase()) ||
                                        article.KeyWords.toLowerCase().contains(
                                            searchQuery.toLowerCase()))
                                    .toList();

                                return Column(
                                  children: filteredCards.map(
                                    (card) {
                                      String title = card.Title;
                                      String keys = card.KeyWords;

                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              image: DecorationImage(
                                                image: NetworkImage(card.image),
                                                fit: BoxFit
                                                    .cover, // You can choose different BoxFit options based on your needs
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .white, // Adjust text color to be visible on the image
                                                ),
                                              ),
                                              subtitle: Text('Keywords: $keys',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () {},
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                            ),
                            StreamBuilder<List<Article>>(
                              stream: FirestoreService().streamMyArticles(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                List<Article> cards = snapshot.data ?? [];

                                List<Article> filteredCards = cards
                                    .where((article) =>
                                        article.Title.toLowerCase().contains(
                                            searchQuery.toLowerCase()) ||
                                        article.KeyWords.toLowerCase().contains(
                                            searchQuery.toLowerCase()))
                                    .toList();

                                return Column(
                                  children: filteredCards.map(
                                    (card) {
                                      String title = card.Title;
                                      String keys = card.KeyWords;
                                      var time = card.PublishTime;

                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              image: DecorationImage(
                                                image: NetworkImage(card.image),
                                                fit: BoxFit
                                                    .cover, // You can choose different BoxFit options based on your needs
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .white, // Adjust text color to be visible on the image
                                                ),
                                              ),
                                              subtitle: Text('Keywords: $keys',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () {},
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                            ),
                            Text('no favorites yet')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
