// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Interest {
  final int id;
  final String interest;
  Interest({
    required this.id,
    required this.interest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'interest': interest,
    };
  }

  factory Interest.fromMap(Map<String, dynamic> map) {
    return Interest(
      id: map['id'] as int,
      interest: map['interest'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Interest.fromJson(String source) => Interest.fromMap(json.decode(source) as Map<String, dynamic>);
}
