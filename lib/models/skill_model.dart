// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Skill {
  final String skill;
  final int id;
  Skill({
    required this.id,
    required this.skill,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'skill': skill,
      'id': id,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      skill: map['skill'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Skill.fromJson(String source) =>
      Skill.fromMap(json.decode(source) as Map<String, dynamic>);
}
