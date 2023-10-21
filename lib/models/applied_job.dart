// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppliedJob {
  final int jobId;
  final String jobStatus;
  final String title;
  final String applicationStatus;

  AppliedJob({
    required this.jobId,
    required this.jobStatus,
    required this.title,
    required this.applicationStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'job_id': jobId,
      'job_status': jobStatus,
      'title': title,
      'application_status': applicationStatus,
    };
  }

  factory AppliedJob.fromMap(Map<String, dynamic> map) {
    return AppliedJob(
      jobId: map['job_id'] as int,
      jobStatus: map['job_status'] as String,
      title: map['title'] as String,
      applicationStatus: map['application_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppliedJob.fromJson(String source) => AppliedJob.fromMap(json.decode(source) as Map<String, dynamic>);
}
