import 'package:flutter/material.dart';
import 'package:fursaapp/widgets/job_view_sheet.dart';

import '../constants/constants.dart';
import '../models/job_model.dart';

class FeaturedJobCard extends StatelessWidget {
  final Jobs job;

  const FeaturedJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            // Build the card UI for the featured job
            child: Container(
              height: 178,
              width: 300,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Image(
                          image: AssetImage('assets/fursa.png'),
                          height: 50,
                          width: 50,
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                          ),
                          onPressed: () {
                            // Do something when the button is pressed.
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return ApplyBottomSheet(
                                    job: job,
                                  );
                                });
                          },
                          icon: const Icon(Icons.timelapse),
                          label: const Text('View Job'),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Text(job.company.name),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.grey,
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Text(job.location.name),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
