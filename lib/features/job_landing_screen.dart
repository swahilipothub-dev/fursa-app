import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/constants/constants.dart';
import 'package:fursaapp/features/jobs/job_controller.dart';
import 'package:fursaapp/features/show_all_jobs.dart';
import 'package:fursaapp/models/job_model.dart';
import '../widgets/featured_job_card.dart';
import '../widgets/recent_job_card.dart';

class JobLandingScreen extends ConsumerStatefulWidget {
  const JobLandingScreen({super.key});

  @override
  ConsumerState<JobLandingScreen> createState() => _JobLandingScreenState();
}

class _JobLandingScreenState extends ConsumerState<JobLandingScreen> {
  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  List<Jobs> recentJobs = [];
  fetchJobs() {
    final res = ref.read(jobsProvider);
    if (res != null) {
      setState(() {
        recentJobs = res;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ShowAllJobs(
                          isFromSearch: true,
                        ),
                      ),
                    ),
                    child: Container(
                        height: 50,
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
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.search),
                            ),
                            Text(
                              "search",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(width: 16.0),
               /* Material(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  elevation: 3.0,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // // Handle filter button tap
                      // showBottomSheet(context: context, builder: (BuildContext context){
                      //   return const SetFilterSheet();
                      // });
                    },
                  ),
                ), */
              ],
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Featured Jobs',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Show All',
                    style: TextStyle(color: AppColors.primaryColor),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentJobs.length,
                itemBuilder: (BuildContext context, int index) {
                  // Build and return a featured job card widget
                  return FeaturedJobCard(job: recentJobs[index]);
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Recent Jobs',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShowAllJobs(
                                  isFromSearch: false,
                                )),
                      );
                    },
                    child: const Text(
                      'Show All',
                      style: TextStyle(
                        color:
                            AppColors.primaryColor, // Upwork app's text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentJobs.length,
              itemBuilder: (BuildContext context, int index) {
                // Build and return a recent job widget
                return RecentJobCard(job: recentJobs[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
