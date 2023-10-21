import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fursaapp/constants/constants.dart';
import 'package:fursaapp/models/job_model.dart';

import '../models/geofencing_model.dart';

class ApplyBottomSheet extends StatefulWidget {
  final Jobs job;
  const ApplyBottomSheet({Key? key, required this.job}) : super(key: key);

  @override
  State<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends State<ApplyBottomSheet> {
  bool showJobDetails = true;
  bool showQualifications = false;
  double latitude = 0.0;
  double longitude = 0.0;

  void toggleView() {
    setState(() {
      showJobDetails = !showJobDetails;
      showQualifications = !showQualifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      color: AppColors.greyshade,
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                const SizedBox(
                  width: 80,
                  child: Divider(
                    height: 4,
                    thickness: 4,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Image(
                  image: AssetImage('assets/fursa.png'),
                  height: 80,
                  width: 60,
                ),
                Text(
                  widget.job.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.job.company.name),
                      const Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.grey,
                      ),
                      Text(
                        '${widget.job.location.name}, Kenya',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4),
                          Text('Contract'),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${widget.job.vacancies} Vacancies',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        toggleView();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showJobDetails
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      child: Text(
                        'Job Description',
                        style: TextStyle(
                          color: showJobDetails ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        toggleView();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showQualifications
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      child: Text(
                        'Qualifications',
                        style: TextStyle(
                          color:
                              showQualifications ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (showJobDetails)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(widget.job.description),
                  ),
                if (showQualifications)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(widget.job.description),
                  ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                        ),
                        onPressed: () {
                          checkLocationAndApply(context, widget.job);
                          // Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => JobApplyScreen(
                          //       jobId: widget.job.id,
                          //     ),
                          //   ),
                          // );
                        },
                        child: const Text('Apply Job'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                        ),
                        onPressed: () {
                          Share.text(
                            "Hey,checkout this job at Fursa App",
                            'https://play.google.com/store/apps/details?id=swahilipot.fursa.app',
                            "text/plain",
                          );
                        },
                        child: const Text('Share Job'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
