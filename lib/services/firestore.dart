import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<Therapist> streamTherapist() {
    //not yet working
    var user = AuthService().user;
    if (user != null) {
      var ref = _db.collection('Therapist').doc(user.uid);
      return ref.snapshots().map((doc) => Therapist.fromJson(doc.data()!));
    } else {
      return Stream.fromIterable([Therapist()]);
    }
  }

  Future<void> updateTherapist(Map<String, dynamic> newData) async {
    //not yet working
    var user = AuthService().user!;
    try {
      CollectionReference articlesCollection = _db.collection('Therapist');
      await articlesCollection.doc(user.uid).update(newData);
    } catch (e) {
      print('Error updating therapist: $e');
      throw e;
    }
  }

  Stream<List<Patient>> streamPatients() {
    //(works well)
    var ref = _db.collection('Patient');
    var user = AuthService().user!;

    return ref
        .where('TheraID', isEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Patient.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<Patient> streamPatient(String pNum) {
    //(works well)
    var user = AuthService().user;
    if (user != null) {
      var ref = _db.collection('Patient').doc(pNum);
      return ref.snapshots().map((doc) => Patient.fromJson(doc.data()!));
    } else {
      return Stream.fromIterable([Patient()]);
    }
  }

  Future<void> addPatient(Patient patient) async {
    //(works well)
    var user = AuthService().user!;

    try {
      CollectionReference articlesCollection = _db.collection('Patient');
      await articlesCollection.add({
        'Patient Name': patient.name,
        'Patient Number': patient.phone,
        'Email': patient.email,
        'TheraID': user.uid,
      });
    } catch (e) {
      print('Error adding patient: $e');
      throw e;
    }
  }

  Future<void> updatePatient(String pNum, Map<String, dynamic> newData) async {
    //(works well)
    try {
      CollectionReference articlesCollection = _db.collection('Patient');
      await articlesCollection.doc(pNum).update(newData);
    } catch (e) {
      print('Error updating patient: $e');
      throw e;
    }
  }

  Stream<List<Article>> streamArticles() {
    //(works well)
    var ref = _db.collection('Article');
    return ref.snapshots().map((QuerySnapshot snapshot) {
      List<Article> articles = [];
      snapshot.docs.forEach((DocumentSnapshot document) {
        Article article =
            Article.fromJson(document.data() as Map<String, dynamic>);
        articles.add(article);
      });
      return articles;
    });
  }

  Stream<List<Article>> streamMyArticles() {
    //(works well)
    var ref = _db.collection('Article');
    var user = AuthService().user!;

    return ref
        .where('auhtorID', isEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Article.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<Article> streamArticle(String aid) {
    //(not tried yet)
    var user = AuthService().user;
    if (user != null) {
      var ref = _db.collection('Article').doc(aid);
      return ref.snapshots().map((doc) => Article.fromJson(doc.data()!));
    } else {
      return Stream.fromIterable([Article(PublishTime: Timestamp.now())]);
    }
  }

  Future<void> addArticle(Article article) async {
    //(works well)
    var user = AuthService().user!;
    try {
      CollectionReference articlesCollection = _db.collection('Article');
      await articlesCollection.add({
        'Title': article.Title,
        'Content': article.Content,
        'PublishTime': article.PublishTime,
        'authorID': article.autherID,
        'KeyWords': article.KeyWords,
      });
    } catch (e) {
      print('Error adding article: $e');
      throw e;
    }
  }

  Future<void> updateArticle(
      String articleId, Map<String, dynamic> newData) async {
    //(works well)
    try {
      CollectionReference articlesCollection = _db.collection('Article');
      await articlesCollection.doc(articleId).update(newData);
    } catch (e) {
      print('Error updating article: $e');
      throw e;
    }
  }
}
