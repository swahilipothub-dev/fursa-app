import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fursaapp/constants/typedefs.dart';
import 'package:fursaapp/constants/urls.dart';
import 'package:fursaapp/models/applied_job.dart';
import 'package:fursaapp/models/job_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final jobsRepoProvider = Provider<JobRepo>((ref) {
  return JobRepo(client: http.Client());
});

class JobRepo {
  final http.Client _client;
  JobRepo({required http.Client client}) : _client = client;
  FutureEither<List<Jobs>> fetchJobs(String token) async {
    try {
      final url = Uri.parse(AppUrls.jobsUrl);
      final response = await _client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final List<dynamic> jsonList = json.decode(response.body)['jobs'];
      final List<Jobs> jobs = jsonList
          .map((json) => Jobs(
                id: json['id'] as int,
                title: json['title'] as String,
                description: json['description'] as String,
                skills: (json['skills'] as List<dynamic>)
                    .map((skillJson) => Skill(
                          id: skillJson['id'] as int,
                          skill: skillJson['skill'] as String,
                        ))
                    .toList(),
                applicants: json['applicants'] as int,
                vacancies: json['vacancies'] as int,
                location: Location(
                  id: json['location']['id'] as int,
                  name: json['location']['name'] as String,
                ),
                type: json['type'] as String,
                status: json['status'] as String,
                company: Company(
                  name: json['company']['name'] as String,
                  profilePic: json['company']['profile_pic'] as String?,
                ),
              ))
          .toList();

      return Right(jobs);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> makeApplication(
      String token, int jobId, String cvFile) async {
    Logger logger = Logger();
    try {
      final url = Uri.parse(AppUrls.jobApplicationsUrl);
      final res = await _client.post(
        url,
        headers: {"Authorization": "Bearer $token"},
        body: {
          "job_id": jobId.toString(),
          "cv_file": cvFile,
        },
      );
      final response = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return Right(response['message']);
      } else if (res.statusCode == 400) {
        if (response.containsKey('error')) {
          if (response['error'].containsKey('job_id')) {
            final errorMessage = response['error']['job_id'][0];
            return Left(errorMessage);
          } else if (response['error'].containsKey('cv_file')) {
            final errorMessage = response['error']['cv_file'][0];
            return Left(errorMessage);
          }
        }
      }
      logger.e(response);
      return const Left('Unknown error occurred.');
    } catch (e) {
      return Left(e.toString());
    }
  }

  FutureEither<List<AppliedJob>> getAppliedJobs(String token) async {
    try {
      final url = Uri.parse(AppUrls.appliedJobs);
      final res = await _client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (res.statusCode != 200) {
        throw Exception(res.body);
      }
      final Map<String, dynamic> responseData = json.decode(res.body);
      final List<dynamic> jobList = responseData['applied_jobs'];
      final List<AppliedJob> jobs =
          jobList.map((job) => AppliedJob.fromMap(job)).toList();
      return Right(jobs);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
