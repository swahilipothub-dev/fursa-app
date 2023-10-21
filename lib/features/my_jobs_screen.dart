import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/features/jobs/job_controller.dart';
import 'package:fursaapp/models/applied_job.dart';
import 'package:fursaapp/theme.dart/theme.dart';

class MyJobsPage extends ConsumerStatefulWidget {
  const MyJobsPage({super.key});

  @override
  ConsumerState<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends ConsumerState<MyJobsPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  List<AppliedJob> jobs = [];
  init() {
    final res = ref.read(appliedJobsProvider);
    if (res != null) {
      setState(() {
        jobs = res;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return jobs.isEmpty
        ? const Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/dizzy.png'),height: 300,),
            SizedBox(height:8,),
            Text("No jobs applied yet !",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: AppTheme.primaryColor),),
          ],
        ))
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Image(image: AssetImage('assets/suitcase.png',)),
                    title: Text(jobs[index].title,style: const TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: const Text("Applied"),
                    trailing: Column(
                      children: [
                        const Text('Status',style: TextStyle(color: AppTheme.secondaryColor,fontWeight: FontWeight.bold),),
                        Text(jobs[index].applicationStatus),
                      ],
                    ),
                  ),
                );
              },
              itemCount: jobs.length,
            ),
          );
  }
}
