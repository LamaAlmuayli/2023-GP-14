//all classes that will be converted to objects
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Therapist {
  final String name;
  final String jobTitle;
  final String hospitalClinic;
  final String email;
  final String password;

  Therapist({
    this.name = '',
    this.jobTitle = '',
    this.hospitalClinic = '',
    this.email = '',
    this.password = '',
  });
  factory Therapist.fromJson(Map<String, dynamic> json) =>
      _$TherapistFromJson(json);
  Map<String, dynamic> toJson() => _$TherapistToJson(this);
}

@JsonSerializable()
class Patient {
  final String name;
  final String phone;
  final String email;
  final String patientNum;
  final String gender;

  Patient({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.patientNum = '',
    this.gender = '',
  });
  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}

class Article {
  final String Content;
  final String autherID;
  final String KeyWords;
  final Timestamp PublishTime;
  final String Title;
  final String name;
  final String image;

  Article({
    this.Content = '',
    this.KeyWords = '',
    required this.PublishTime,
    this.Title = '',
    this.autherID = '',
    this.name = '',
    this.image = '',
  });
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

class Program {}

class Report {}

class Activity {}
