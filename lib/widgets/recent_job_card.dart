import 'package:flutter/material.dart';
import 'package:fursaapp/widgets/job_view_sheet.dart';

import '../constants/constants.dart';
import '../models/job_model.dart';

class RecentJobCard extends StatelessWidget {
  final Jobs job;

  const RecentJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Build the card UI for a recent job
      child: ListTile(
        leading: const Image(
          image: AssetImage('assets/fursa.png'),
        ),

        title: Text(job.title),
        subtitle: Text(job.title),
        trailing: TextButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                
                context: context,
                builder: (BuildContext context) {
                  return ApplyBottomSheet(job: job,);
                });
          },
          style: TextButton.styleFrom(
          backgroundColor:
                AppColors.secondaryColor, // Set the button text color to green
          ),
          child: const Text('Apply',style: TextStyle(color: Colors.white),),
        ),
        onTap: () {
          // Handle job item tap
        },
      ),
    );
  }
}
