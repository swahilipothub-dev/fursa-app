import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/features/jobs/job_controller.dart';
import 'package:fursaapp/models/job_model.dart';
import 'package:fursaapp/widgets/job_view_sheet.dart';

import '../constants/constants.dart';

class ShowAllJobs extends ConsumerStatefulWidget {
  final bool isFromSearch;
  const ShowAllJobs({super.key, required this.isFromSearch});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowAllJobsState();
}

class _ShowAllJobsState extends ConsumerState<ShowAllJobs> {
  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  List<Jobs> jobs = [];

  fetchJobs() {
    final res = ref.read(jobsProvider);
    if (res != null) {
      setState(() {
        jobs = res;
        filteredJobs = res;
      });
    }
  }

  List<Jobs> filteredJobs = [];
  bool isSearching = false;
  void filterJobs(String keyword) {
    setState(() {
      if (keyword.isNotEmpty) {
        filteredJobs = jobs
            .where((job) =>
                job.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      } else {
        filteredJobs = jobs;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
        title: const Text(
          'All Jobs',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                autofocus: widget.isFromSearch,
                cursorColor: Colors.blue,
                onTapOutside: (event) {
                  final currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onChanged: (value) {
                  setState(() {
                    isSearching = value.isNotEmpty;
                  });
                  filterJobs(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isSearching
                ? filteredJobs.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          return ListTile(
                            leading: const Image(
                              image: AssetImage('assets/fursa.png'),
                            ),
                            title: Text(job.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text('Company: ${jobData['company']['name'] ?? ''}'),
                                Text('Vacancies: ${job.vacancies}'),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                showBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ApplyBottomSheet(
                                        job: job,
                                      );
                                    });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors
                                    .secondaryColor, // Set the button text color to green
                              ),
                              child: const Text('Apply'),
                            ),
                            onTap: () {
                              // Handle job item tap
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No matching jobs found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                : ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return ListTile(
                        leading: const Image(
                          image: AssetImage('assets/fursa.png'),
                        ),
                        title: Text(job.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Text('Company: ${jobData['company']['name'] ?? ''}'),
                            Text('Vacancies: ${job.vacancies}'),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            showBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return ApplyBottomSheet(
                                    job: job,
                                  );
                                });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors
                                .secondaryColor, // Set the button text color to green
                          ),
                          child: const Text('Apply'),
                        ),
                        onTap: () {
                          // Handle job item tap
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
