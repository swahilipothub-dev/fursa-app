import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/models/highest_level.dart';
import 'package:fursaapp/models/interest_model.dart';
import 'package:fursaapp/models/profile_item_model.dart';
import 'package:logger/logger.dart';

import '../models/location_model.dart';
import '../models/skill_model.dart';
import 'profile_items_repo.dart';

final locationsProvider = StateProvider<List<Location>?>((ref) {
  return null;
});
final interestProvider = StateProvider<List<Interest>?>((ref) {
  return null;
});
final skillProvider = StateProvider<List<Skill>?>((ref) {
  return null;
});
final highestLevelProvider = StateProvider<List<HighestLevel>?>((ref) {
  return null;
});
final profileItemsControllerProvider = Provider((ref) {
  return ProfileItemsController(
      profileItemsRepository: ref.read(profileItemsRepoProvider), ref: ref);
});

class ProfileItemsController {
  final ProfileItemsRepository _profileItemsRepository;
  final Ref _ref;
  ProfileItemsController(
      {required ProfileItemsRepository profileItemsRepository,
      required Ref ref})
      : _profileItemsRepository = profileItemsRepository,
        _ref = ref;

  Future getLocations({
    required BuildContext context,
    required String token,
  }) async {
    final res = await _profileItemsRepository.getLocations(token);

    res.fold((l) {}, (r) {
      _ref.read(locationsProvider.notifier).update((state) => r);
    });
  }

  Future getSkills({
    required BuildContext context,
    required String token,
  }) async {
    final res = await _profileItemsRepository.getSkills(token);

    res.fold((l) {}, (r) {
      _ref.read(skillProvider.notifier).update((state) => r);
    });
  }

  Future getInterest(
      {required BuildContext context, required String token}) async {
    final res = await _profileItemsRepository.getInterests(token);

    res.fold((l) {}, (r) {
      _ref.read(interestProvider.notifier).update((state) => r);
    });
  }

  Future getHighestLevel({
    required BuildContext context,
    required String token,
  }) async {
    final res = await _profileItemsRepository.getHighestLevel(token);

    res.fold((l) {}, (r) {
      _ref.read(highestLevelProvider.notifier).update((state) => r);
    });
  }

  Future postProfileItems({
    required BuildContext context,
    required ProfileItem item,
    required String token,
  }) async {
    Logger logger = Logger();
    final res = await _profileItemsRepository.postProfileItems(token, item);
    res.fold((l) => logger.e(l), (r) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations! 🎉'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Thank you for submitting your details. You are on your way to finding a job!'),
                SizedBox(height: 16.0),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate to the job landing screen
                  Navigator.pop(context); //pop the dialog
                  Navigator.pop(context); //pop the loader
                  Navigator.popAndPushNamed(
                      context, '/homeController'); //pop the userdetails screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
