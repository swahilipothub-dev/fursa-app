import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/features/auth/screens/reset_password.dart';
import 'package:fursaapp/features/jobs/job_controller.dart';
import 'package:fursaapp/models/registered_user.dart';
import 'package:fursaapp/features/auth/repository/auth_repository.dart';
import 'package:fursaapp/features/profile_items_controller.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authRepository: ref.read(authRepoProvider), ref: ref);
});
final userProvider = StateProvider<RegisteredUser?>((ref) {
  return;
});
final userTokenProvider = StateProvider<String?>((ref) => null);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Future registerUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String email,
  }) async {
    state = true;
    final res = await _authRepository.registerUser(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      password: password,
      email: email,
    );
    state = false;
    res.fold(
      (l) {
        //pop current dialog
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(
                child: Text('Error: $l'),
              ),
            ),
          ),
        );
      },
      (r) async {
        _ref.read(userProvider.notifier).update((state) => r.user);
        _ref.read(userTokenProvider.notifier).update((state) => r.token);
        final navigator = Navigator.of(context);

        await Future.wait([
          _ref
              .read(profileItemsControllerProvider)
              .getSkills(context: context, token: r.token),
          _ref
              .read(profileItemsControllerProvider)
              .getLocations(context: context, token: r.token),
          _ref
              .read(profileItemsControllerProvider)
              .getInterest(context: context, token: r.token),
          _ref
              .read(profileItemsControllerProvider)
              .getHighestLevel(context: context, token: r.token),
          _ref.read(jobsControllerProvider.notifier).fetchJobs(r.token),
        ]);

        navigator.pop();
        navigator.pushReplacementNamed('/userDetails');
      },
    );
  }

  Future loginUser({
    required BuildContext context,
    required String phone,
    required String password,
  }) async {
    state = true;
    final res =
        await _authRepository.loginUser(phone: phone, password: password);
    state = false;
    res.fold(
      (l) {
        //pop current dialog
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(
                child: Text('Error: $l'),
              ),
            ),
          ),
        );
      },
      (r) async {
        _ref.read(userProvider.notifier).update((state) => r.user);
        _ref.read(userTokenProvider.notifier).update((state) => r.token);
        final navigator = Navigator.of(context);
        await Future.wait([
          _ref.read(jobsControllerProvider.notifier).fetchJobs(r.token),
          _ref
              .read(jobsControllerProvider.notifier)
              .getAppliedJobs(token: r.token),
        ]);
        navigator.pop();
        navigator.popAndPushNamed('/homeController');
      },
    );
  }

  Future requestOtp(
      {required BuildContext context, required String phone}) async {
    state = true;
    final res = await _authRepository.requestOtp(phone: phone);
    state = false;
    res.fold((l) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Text('Error: $l'),
            ),
          ),
        ),
      );
    }, (r) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            phone: phone,
          ),
        ),
      );
    });
  }

  Future resetPassword(
      {required BuildContext context,
      required String phone,
      required String otp,
      required String password}) async {
    final res = await _authRepository.resetPassword(
      phone: phone,
      otp: otp,
      password: password,
    );

    res.fold((l) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Text('Error: $l'),
            ),
          ),
        ),
      );
    }, (r) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const SizedBox(
            height: 100,
            child: Center(
              child:
                  Text("Successfully Reset your password\nLogin to continue"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to the login screen
                Navigator.popAndPushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    });
  }

  //delete account
  Future deleteAccount({
    required String token,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepository.deleteAccount(token);
    state = false;
    res.fold((l) {
      print(l);
      //show alet dialog error
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Text('Error: $l'),
            ),
          ),
        ),
      );
    }, (r) {
      //show success
      final navigator = Navigator.of(context);
      navigator.pop();
      navigator.pop();
      navigator.pushReplacementNamed('/login');
    });
  }
}
