// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Therapist _$TherapistFromJson(Map<String, dynamic> json) => Therapist(
      name: json['Full name'] as String? ?? '',
      jobTitle: json['Job Title'] as String? ?? '',
      hospitalClinic: json['HospitalClinic'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      password: json['Password'] as String? ?? '',
    );

Map<String, dynamic> _$TherapistToJson(Therapist instance) => <String, dynamic>{
      'Full name': instance.name,
      'Job Title': instance.jobTitle,
      'HospitalClinic': instance.hospitalClinic,
      'Email': instance.email,
      'Password': instance.password,
    };

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      name: json['Patient Name'] as String? ?? '',
      phone: json['Phone Number'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      patientNum: json['Patient Number'] as String? ?? '',
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'Patient Name': instance.name,
      'Phone Number': instance.phone,
      'Email': instance.email,
      'Patient Number': instance.patientNum,
    };

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      Content: json['Content'] as String? ?? '',
      ID: json['ID'] as int? ?? 0,
      KeyWords: json['KeyWords'] as String? ?? '',
      PublishTime: json['PublishTime'] as Timestamp? ?? Timestamp.now(),
      Title: json['Title'] as String? ?? '',
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'Content': instance.Content,
      'ID': instance.ID,
      'KeyWords': instance.KeyWords,
      'PublishTime': instance.PublishTime,
      'Title': instance.Title,
    };
