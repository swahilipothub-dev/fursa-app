import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fursaapp/constants/urls.dart';
import 'package:fursaapp/models/highest_level.dart';
import 'package:fursaapp/models/location_model.dart';
import 'package:fursaapp/models/profile_item_model.dart';
import 'package:fursaapp/models/skill_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../constants/typedefs.dart';
import '../models/interest_model.dart';

final profileItemsRepoProvider = Provider((ref) {
  return ProfileItemsRepository(client: http.Client());
});

class ProfileItemsRepository {
  final http.Client _client;
  ProfileItemsRepository({required http.Client client}) : _client = client;

  FutureEither<List<Location>> getLocations(String token) async {
    Logger logger = Logger();

    try {
      final url = Uri.parse(AppUrls.locationUrl);
      final response = await _client.get(url, headers: {
        //authorization header
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      final List<Location> locations = [];
      final List<dynamic> locationList = json.decode(response.body);
      for (final Map<String, dynamic> garden in locationList) {
        locations.add(Location.fromMap(garden));
      }
      logger.d(locations);
      return right(locations);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<List<Interest>> getInterests(String token) async {
    Logger logger = Logger();
    try {
      final url = Uri.parse(AppUrls.interestUrl);
      final response = await _client.get(url, headers: {
        //authorization header
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      final List<Interest> interests = [];
      final List<dynamic> interestList = json.decode(response.body);
      for (final Map<String, dynamic> interest in interestList) {
        interests.add(Interest.fromMap(interest));
      }
      logger.d(interests);

      return right(interests);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<List<Skill>> getSkills(String token) async {
    Logger logger = Logger();
    try {
      final url = Uri.parse(AppUrls.skillsUrl);
      final response = await _client.get(url, headers: {
        //authorization header
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      final List<Skill> skills = [];
      final List<dynamic> skillsList = json.decode(response.body);
      for (final Map<String, dynamic> skill in skillsList) {
        skills.add(Skill.fromMap(skill));
      }
      logger.d(skills);

      return right(skills);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<List<HighestLevel>> getHighestLevel(String token) async {
    Logger logger = Logger();
    try {
      final url = Uri.parse(AppUrls.educationUrl);
      final response = await _client.get(url, headers: {
        //authorization header
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      final List<HighestLevel> highestLevel = [];
      final List<dynamic> levelList = json.decode(response.body);
      for (final Map<String, dynamic> level in levelList) {
        highestLevel.add(HighestLevel.fromMap(level));
      }
      logger.d(highestLevel);

      return right(highestLevel);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  //post items
  FutureEither<String> postProfileItems(
      String token, ProfileItem postItem) async {
    Logger logger = Logger();
    try {
      final url = Uri.parse(AppUrls.profileUrl);
      final res = await _client.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: postItem.toJson(),
      );
      if (res.statusCode != 200) {
        final err = jsonDecode(res.body)['message'];
        throw Exception('Error $err');
      }
      final String successMessage = jsonDecode(res.body)['message'];
      return right(successMessage);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }
}
