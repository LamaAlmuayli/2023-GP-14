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

  Patient({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.patientNum = '',
  });
  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}

class Article {
  final String Content;
  final int ID;
  final String KeyWords;
  final Timestamp PublishTime;
  final String Title;

  Article({
    this.Content = '',
    this.ID = 0,
    this.KeyWords = '',
    required this.PublishTime,
    this.Title = '',
  });
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

class Program {}

class Report {}

class Activity {}
