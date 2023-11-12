// import 'dart:core';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/services/firestore.dart';
// import 'package:flutter_application_1/services/models.dart';
// import 'package:flutter_application_1/shared/background.dart';

// class View_article extends StatefulWidget {
//   final String id;
//   const View_article({Key? key, required this.id}) : super(key: key);

//   @override
//   View_article_State createState() => View_article_State();
// }

// class View_article_State extends State<View_article> {
//   late Stream<QuerySnapshot<Map<String, dynamic>>> ArticleStream =
//       FirebaseFirestore.instance.collection('Article').snapshots();

//   Future<void> deleteArticle(String id) async {
//     bool? deleteConfirmed = await showDialog<bool?>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           title: Text('Confirmation'),
//           content: Text('Are you sure you want to delete this article?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: Text(
//                 'Yes',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (deleteConfirmed == true) {
//       try {
//         await FirebaseFirestore.instance.collection('Article').doc(id).delete();
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Article is deleted successfully')));
//       } catch (e) {
//         print('Error deleting article: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to delete the article')));
//       }
//     }
//   }

//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) => StreamBuilder<Article>(
//         stream: FirestoreService().streamArticle(widget.id),
//         builder: (context, snapshot) {
//           Article article = snapshot.data!;
//           String Title = article.Title;
//           String Content = article.Content;

//           return Scaffold(
//             appBar: AppBar(
//               backgroundColor: Color(0xFF186257),
//               elevation: 0.0,
//               actions: <Widget>[
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'Delete') {
//                       deleteArticle(widget.id);
//                     } else if (value == 'Edit') {
//                       print('Edit');
//                     }
//                   },
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       value: 'Delete',
//                       child: Text('Delete'),
//                     ),
//                     PopupMenuItem(
//                       value: 'Edit',
//                       child: Text('Edit'),
//                     ),
//                   ],
//                   child: Icon(
//                     Icons.more_vert,
//                     size: 28,
//                   ),
//                   offset: Offset(0, 32),
//                   padding: EdgeInsets.symmetric(horizontal: 25),
//                 ),
//               ],
//             ),
//             body: Stack(
//               children: [
//                 Background(),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height / 2,
//                     color: Color.fromRGBO(24, 98, 87, 1),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: FractionallySizedBox(
//                     heightFactor: 0.65,
//                     child: Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Stack(
//                               children: [
//                                 Positioned(
//                                   top: -10,
//                                   right: 10,
//                                   child: IconButton(
//                                     icon: Icon(
//                                       isFavorite
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: Color.fromARGB(255, 229, 89, 114),
//                                       size: 40,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         isFavorite = !isFavorite;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.fromLTRB(7, 0, 6, 0),
//                                   child: Text(
//                                     Title,
//                                     style: TextStyle(
//                                       fontSize: 25,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'Merriweather',
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
//                               child: Text(
//                                 Content,
//                                 style: TextStyle(
//                                   color: Color.fromARGB(255, 62, 62, 62),
//                                   fontSize: 17,
//                                   fontFamily: 'Merriweather',
//                                 ),
//                                 textAlign: TextAlign.justify,
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
// }

// extension StringValidation on String {
//   bool get isAlphaOnly => this.runes.every(
//         (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122),
//       );
// }
