// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/services/firestore.dart';
import 'package:flutter_application_1/services/models.dart';
import 'package:flutter_application_1/shared/background.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class Write_article extends StatefulWidget {
  const Write_article({super.key});

  @override
  State<Write_article> createState() => _Write_article_State();
}

class _Write_article_State extends State<Write_article> {
  String imageUrl = '';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _articleController = TextEditingController();
  final _keywordsController = TextEditingController();
  File? selectedImage;
  List<String> keywordsList = [];
  bool pressed = false;
  late String name;

  @override
  void initState() {
    super.initState();
    //name = (FirestoreService().streamTherapist() as Therapist).name;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImageToUpload.putFile(File(pickedFile.path));

        imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (error) {}

      setState(() {
        // _imageController.text = pickedFile.path;
      });
    } else {
      Text("no image");
    }
  }

  void extractKeywords() {
    keywordsList = _keywordsController.text.split(',');
  }

  var user = AuthService().user;
  var time = FieldValue.serverTimestamp();

  Future Publish() async {
    extractKeywords();
    Map<String, dynamic> dataToSave = {
      'AutherID': user!.uid,
      //'name': name,
      'PublishTime': FieldValue.serverTimestamp(),
      'Title': _titleController.text,
      'Content': _articleController.text,
      'KeyWords': keywordsList,
      'image': imageUrl,
    };

    bool allFieldsNotEmpty = true;

    dataToSave.forEach((key, value) {
      if (key != 'PublishTime' && (value == null || value.isEmpty)) {
        allFieldsNotEmpty = false;
      }
    });

    if (allFieldsNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Article')
          .doc(user!.uid + '$time')
          .set(dataToSave);
      Navigator.of(context).pushNamed('homepage');
    } else {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Please fill out the fields.'),
        ),
      );
    }

    setState(() {
      pressed = selectedImage == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        bottomNavigationBar: NavBar(),
        appBar: AppBar(
          backgroundColor: Color(0xFF186257),
          elevation: 0.0,
        ),
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
                heightFactor: 0.95,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(90),
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
                        SizedBox(height: 20),
                        Text(
                          'Write an article',
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Title:',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _titleController,
                              decoration: InputDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              },
                              maxLines: null,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Content:',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _articleController,
                              decoration: InputDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Article is required';
                                }
                                return null;
                              },
                              maxLines: null,
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Key words',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Merriweather',
                                  ),
                                ),
                                Text(
                                  '(Separated by commas):',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Merriweather',
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _keywordsController,
                              decoration: InputDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Keywords are required';
                                }
                                return null;
                              },
                              maxLines: null,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Image:',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: _pickImage,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.upload,
                                        size: 25,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                if (selectedImage != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Image.file(
                                      selectedImage!,
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                if (selectedImage == null && pressed)
                                  Visibility(
                                    visible: selectedImage == null && pressed,
                                    child: Text(
                                      'No image selected',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 196, 0, 0),
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: Publish,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF186257),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Publish',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Merriweather',
                                  ),
                                ),
                              ),
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

        // ],
      ),
    );
    // );
  }
}

extension StringValidation on String {
  bool get isAlphaOnly => this.runes.every(
      (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122));
}
