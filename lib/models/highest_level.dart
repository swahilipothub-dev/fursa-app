// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HighestLevel {
  final int id;
  final String name;
  HighestLevel({
    required this.id,
    required this.name,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory HighestLevel.fromMap(Map<String, dynamic> map) {
    return HighestLevel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HighestLevel.fromJson(String source) => HighestLevel.fromMap(json.decode(source) as Map<String, dynamic>);
}
