import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/features/jobs/job_repository.dart';
import 'package:fursaapp/models/applied_job.dart';
import 'package:logger/logger.dart';

import '../../models/job_model.dart';

final appliedJobsProvider = StateProvider<List<AppliedJob>?>((ref) {
  return null;
});

final jobsProvider = StateProvider<List<Jobs>?>((ref) {
  return null;
});
final loading = StateProvider<bool>((ref) => false);

final jobsControllerProvider =
    StateNotifierProvider<JobsController, bool>((ref) {
  return JobsController(jobRepo: ref.read(jobsRepoProvider), ref: ref);
});

class JobsController extends StateNotifier<bool> {
  final JobRepo _jobRepo;
  final Ref _ref;
  JobsController({required JobRepo jobRepo, required Ref ref})
      : _jobRepo = jobRepo,
        _ref = ref,
        super(false);

  Future fetchJobs(String token) async {
    Logger logger = Logger();
    state = true;
    logger.v('Fetching jobs...');
    final res = await _jobRepo.fetchJobs(token);
    state = false;

    res.fold(
      (l) => logger.e('Error fetching jobs: $l'),
      (r) {
        logger.d('Jobs fetched successfully!');
        logger.d('Number of jobs: ${r.length}');
        _ref.read(jobsProvider.notifier).update((state) => r);
      },
    );
  }

  Future makeApplication({
    required BuildContext context,
    required String token,
    required int jobId,
    required String cvFile,
  }) async {
    Logger logger = Logger();
    state = true;
    final res = await _jobRepo.makeApplication(token, jobId, cvFile);
    res.fold(
      (l) {
        state = false;

        logger.e(l);
      },
      (r) async {
        final nav = Navigator.of(context);
        Future.wait([
          _ref
              .read(jobsControllerProvider.notifier)
              .getAppliedJobs(token: token)
        ]);
        state = false;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            content: const SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(
                      Icons.check_circle,
                      size: 50,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Application submitted successfully!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  nav.pop();
                  nav.pop();
                  nav.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getAppliedJobs({required String token}) async {
    Logger logger = Logger();
    _ref.read(loading.notifier).state = true;
    final res = await _jobRepo.getAppliedJobs(token);
    _ref.read(loading.notifier).state = true;
    res.fold(
      (l) => logger.e(l),
      (r) => _ref.read(appliedJobsProvider.notifier).update((state) => r),
    );
  }
}
