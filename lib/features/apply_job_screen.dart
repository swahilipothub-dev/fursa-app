import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/constants/constants.dart';
import 'package:fursaapp/features/auth/controller/auth_controller.dart';
import 'package:fursaapp/features/jobs/job_controller.dart';
import 'package:fursaapp/theme.dart/theme.dart';
import 'package:file_picker/file_picker.dart';

class JobApplyScreen extends ConsumerStatefulWidget {
  final int jobId;
  const JobApplyScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends ConsumerState<JobApplyScreen> {
  bool _isSubmitting = false;
  // bool _submissionSuccess = false;
  String? _selectedCVFilePath;
  String? _selectedCVFileName;
  // String? _selectedCoverLetterFilePath;
  // String? _selectedCoverLetterFileName;

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(userTokenProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Fursa Job Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Upload Your CV',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _pickCVFile,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedCVFileName != null
                              ? Icons.upload_file_outlined
                              : Icons.upload_file,
                          size: 48.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            _selectedCVFileName != null
                                ? _selectedCVFileName!
                                : 'Choose File',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () => submitApplication(
                        token!,
                        widget.jobId,
                        _selectedCVFilePath,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSubmitting
                    ? AppTheme.primaryColor
                    : AppColors.secondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Submit Application',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickCVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf'], // Only allow document files
    );

    if (result != null) {
      setState(() {
        _selectedCVFilePath = result.files.single.path;
        _selectedCVFileName = result.files.single.name;
      });
    }
  }

  void submitApplication(String token, int jobId, String? cvFilePath) async {
    setState(() {
      _isSubmitting = true;
    });

    // // Convert the files to base64 strings
    // final cvFileData = await File(cvFilePath!).readAsBytes();
    // final cvBase64 = base64Encode(cvFileData);

    // // Uncomment the following lines if you want to convert the cover letter file as well
    // // final coverLetterFileData = await File(coverLetterFilePath!).readAsBytes();
    // //  final coverLetterBase64 = base64Encode(coverLetterFileData);

    await ref.read(jobsControllerProvider.notifier).makeApplication(
          token: token,
          jobId: jobId,
          cvFile: "cvBase64",
          context: context,
          // coverLetterFile: coverLetterBase64,
        );
  }
}
