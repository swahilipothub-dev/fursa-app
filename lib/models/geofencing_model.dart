import 'dart:convert';
import 'dart:io';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:fursaapp/constants/urls.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../features/apply_job_screen.dart';
import 'job_model.dart';


void checkLocationAndApply(BuildContext context, Jobs job) async {
  final navigator = Navigator.of(context);
  Logger logger = Logger();

  try {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        barrierDismissible: false,
        context: navigator.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permission Required'),
            content:
                const Text('Please grant permission to access your location.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;
    logger.d('Latitude: $latitude');
    logger.d('Longitude: $longitude');

    const url = AppUrls.geofenceUrl;

    final response = await http.post(
      Uri.parse(url),
      body: {
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['status'] != null && responseData['status'] is bool) {
        final isWithinMombasa = responseData['status'];

        if (isWithinMombasa) {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => JobApplyScreen(
                jobId: job.id,
              ),
            ),
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: navigator.context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Job Application Restricted'),
                content: const Text(
                  'This job is only available for applicants located in Mombasa County.',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Share Job'),
                    onPressed: () async {
                      String appStoreLink;

                      // Check the platform type
                      if (Platform.isIOS) {
                        // Apple App Store link
                        appStoreLink = 'https://apps.apple.com';
                      } else if (Platform.isAndroid) {
                        // Google Play Store link
                        appStoreLink =
                            'https://play.google.com/store/apps/details?id=swahilipot.fursa.app';
                      } else {
                        return;
                      }
                      
                      // Launch the App Store
                      Share.text(
                        "Hey,checkout this job at Fursa App",
                        appStoreLink,
                         "text/plain"
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        logger.e('Invalid response data: $responseData');
      }
    } else {
      logger.e('Error: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Error obtaining location: $e');
  }
}
