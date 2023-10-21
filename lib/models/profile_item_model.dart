// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:file_picker/file_picker.dart';

class ProfileItem {
  final String dateOfBirth;
  final String idNumber;
  final int locationId;
  final int highestLevelId;
  final String school;
  final List<String> skillId;
  final List<String> interestId;
  final String yearOfCompletion;
  final String resume;
  PlatformFile? resumeFile;
  ProfileItem({
    required this.resume,
    required this.school,
    required this.dateOfBirth,
    required this.idNumber,
    required this.locationId,
    required this.highestLevelId,
    required this.skillId,
    required this.interestId,
    required this.yearOfCompletion,
    required this.resumeFile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date_of_birth': dateOfBirth,
      'id_number': idNumber,
      'location_id': locationId,
      'highest_level_id': highestLevelId,
      'school': school,
      'skill_id': skillId,
      'interest_id': interestId,
      'year_of_completion': yearOfCompletion,
      'resume': resume,
    };
  }

  factory ProfileItem.fromMap(Map<String, dynamic> map) {
    return ProfileItem(
      dateOfBirth: map['date_of_birth'] as String,
      idNumber: map['id_number'] as String,
      locationId: map['location_id'] as int,
      highestLevelId: map['highest_level_id'] as int,
      school: map['school'] as String,
      skillId: List<String>.from((map['skill_id'] as List<String>)),
      interestId: List<String>.from((map['interest_id'] as List<String>)),
      yearOfCompletion: map['year_of_completion'] as String,
      resume: map['resume'] as String, resumeFile: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileItem.fromJson(String source) =>
      ProfileItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
