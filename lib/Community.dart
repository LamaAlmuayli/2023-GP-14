// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart';
import 'package:flutter_application_1/services/models.dart';
import 'package:flutter_application_1/shared/bottom_nav.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';
import 'package:intl/intl.dart';

class CommunityItem extends StatefulWidget {
  @override
  _CommunityItemState createState() => _CommunityItemState();
}

class _CommunityItemState extends State<CommunityItem> {
  List<String> tabs = ["Community", "My Articles", "Favourite"];

  int current = 0;

  double changePositionedOfLine() {
    switch (current) {
      case 0:
        return 0;
      case 1:
        return MediaQuery.of(context).size.width / 3;
      case 2:
        return 2 * (MediaQuery.of(context).size.width / 3);
      default:
        return 0;
    }
  }

  final keywordController = TextEditingController();
  final articleCollection = FirebaseFirestore.instance.collection("Article");

  Stream<QuerySnapshot>? articleStream;
  String userText = '';

  void _onKeywordChanged() {
    final textEntered = keywordController.text.toLowerCase();
    if (textEntered.isNotEmpty) {
      articleStream = articleCollection
          .where("keywords", arrayContains: textEntered)
          .snapshots();
    } else {
      articleStream = articleCollection.snapshots();
    }
    setState(() {
      userText = textEntered;
    });
  }

  @override
  void dispose() {
    keywordController.removeListener(_onKeywordChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const Text(
            'Community',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Merriweather',
            ),
          ),
          const SizedBox(height: 80),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0x00d9d9d9).withOpacity(0.7),
              ),
              child: TextField(
                controller: keywordController,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by the keyword',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: size.height * 0.1,
            child: Stack(
              children: [
                Positioned(
                  top: size.height * 0.04,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                        },
                        child: Text(
                          tab,
                          style: TextStyle(
                              fontSize: current == index ? 16 : 14,
                              fontFamily: 'Merriweather',
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: changePositionedOfLine(),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: size.width / 4,
                    height: size.height * 0.008,
                    decoration: BoxDecoration(
                      color: Color(0xFF186257),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Column(
          //   children: [
          Expanded(
            child: StreamBuilder<List<Article>>(
              stream: FirestoreService().streamArticles(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Article>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Text('No articles found');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data![index];
                    final title = document.Title;
                    final publishTime = document.PublishTime;
                    final KeyWords = document.KeyWords;
                    final imageUrl = document.image;

                    return Visibility(
                      visible: current == 0,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        height: 250,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(imageUrl), fit: BoxFit.cover),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Container(
                          height: 250,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: [0.5, 1],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'Merriweather',
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    KeyWords,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'Merriweather',
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    publishTime != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(publishTime.toDate())
                                        : '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: current == 1
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to the add article screen
                // Navigator.of(context).pushNamed('AddArticleScreen');
              },
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF186257),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: bottomNavBar(),
    );
  }
}
