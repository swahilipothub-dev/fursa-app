// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegisteredUser {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final int id;

  RegisteredUser({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'id': id,
    };
  }

  factory RegisteredUser.fromMap(Map<String, dynamic> map) {
    return RegisteredUser(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisteredUser.fromJson(String source) => RegisteredUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
