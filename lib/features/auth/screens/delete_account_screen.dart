import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/features/auth/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

import '../controller/auth_controller.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/sad.png', // Replace with the actual path to your sad GIF
              width: 400,
              height: 400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                _showDeleteConfirmationDialog(context, isLoading);
              },
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, bool isLoading) {
    final token = ref.read(userTokenProvider)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: ref.watch(authControllerProvider)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.',
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the page too
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                ref
                    .read(authControllerProvider.notifier)
                    .deleteAccount(token: token, context: context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
