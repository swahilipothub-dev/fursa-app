import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/constants/urls.dart';
import 'package:fursaapp/models/registered_user.dart';
import 'package:http/http.dart' as http;

import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

final authRepoProvider = Provider((ref) {
  return AuthRepository(client: http.Client());
});
typedef FutureEither<T> = Future<Either<String, T>>;
typedef FutureVoid = FutureEither<void>;

class AuthRepository {
  final http.Client _client;
  AuthRepository({required http.Client client}) : _client = client;

  FutureEither<UserTokenResponse> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String email,
  }) async {
    Logger logger = Logger();
    try {
      final res = await _client.post(Uri.parse(AppUrls.registerUrl), body: {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "password": password,
        "email": email,
      });
      if (res.statusCode != 200) {
        final errorMessage = jsonDecode(res.body)['error'];
        throw Exception(errorMessage);
      }
      final response = jsonDecode(res.body);

      final registeredUser = RegisteredUser.fromMap(response['seeker']);
      final String token = response['token'];
      final userTokenResponse =
          UserTokenResponse(user: registeredUser, token: token);
      logger.d(userTokenResponse.token);

      return right(userTokenResponse);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<UserTokenResponse> loginUser(
      {required String phone, required String password}) async {
    Logger logger = Logger();
    try {
      final res = await _client.post(Uri.parse(AppUrls.loginUrl), body: {
        "phone": phone,
        "password": password,
      });
      if (res.statusCode != 200) {
        final errorMessage = jsonDecode(res.body)['error'];
        throw Exception(errorMessage);
      }
      final response = jsonDecode(res.body);

      final registeredUser = RegisteredUser.fromMap(response['seeker']);
      final String token = response['token'];
      logger.d(token);
      final userTokenResponse =
          UserTokenResponse(user: registeredUser, token: token);

      return right(userTokenResponse);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<String> requestOtp({required String phone}) async {
    try {
      final res = await _client.post(Uri.parse(AppUrls.requestOtp), body: {
        "phone": phone,
      });
      if (res.statusCode != 200) {
        final errorMessage = jsonDecode(res.body)['error'];
        throw Exception(errorMessage);
      }
      final response = jsonDecode(res.body);
      final String message = response['message'];
      return right(message);
    } catch (e) {
      Logger logger = Logger();
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<String> resetPassword(
      {required String phone,
      required String otp,
      required String password}) async {
    try {
      final res = await _client.post(Uri.parse(AppUrls.resetPassword), body: {
        "phone": phone,
        "password": password,
        "otp": otp,
      });
      if (res.statusCode != 200) {
        final errorMessage = jsonDecode(res.body)['error'];
        throw Exception(errorMessage);
      }
      final response = jsonDecode(res.body);
      final String message = response['message'];
      return right(message);
    } catch (e) {
      Logger logger = Logger();
      logger.e(e);
      return left(e.toString());
    }
  }

  FutureEither<String> deleteAccount(String authToken) async {
    try {
      final res = await _client.delete(
        Uri.parse(AppUrls.deleteAccountUrl),
        headers: {
          'Authorization':
              'Bearer $authToken', // Include the token in the headers
        },
      );

      if (res.statusCode != 200) {
        final errorMessage = jsonDecode(res.body)['error'];
        throw Exception(errorMessage);
      }

      const String message = "User deleted Successfully";
      Logger().d(message);
      return right(message);
    } catch (e) {
      if (e is FormatException) {
        return left('The response from the server is not valid JSON.');
      } else {
        return left(e.toString());
      }
    }
  }
}

class UserTokenResponse {
  final RegisteredUser user;
  final String token;
  UserTokenResponse({required this.user, required this.token});
}
