import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fursaapp/constants/constants.dart';
import 'package:fursaapp/features/auth/controller/auth_controller.dart';
import 'package:fursaapp/features/profile_items_controller.dart';
import 'package:fursaapp/models/highest_level.dart';
import 'package:fursaapp/models/location_model.dart';
import 'package:fursaapp/models/profile_item_model.dart';
import 'package:fursaapp/models/skill_model.dart';
import 'package:fursaapp/theme.dart/textstyles.dart';
import 'package:intl/intl.dart';

import '../../../models/interest_model.dart';


class UserDetailsForm extends ConsumerStatefulWidget {
  const UserDetailsForm({super.key});

  @override
  ConsumerState<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends ConsumerState<UserDetailsForm> {
// Form field controllers
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _educationLevelController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _completionYearController = TextEditingController();

  String? base64Resume; // Variable to store the base64 encoded resume

  GlobalKey<AutoCompleteTextFieldState<String>> locationKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dobController.dispose();
    _idNumberController.dispose();
    _locationController.dispose();
    _educationLevelController.dispose();
    _schoolNameController.dispose();
    _completionYearController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  List<Location> locations = [];
  List<HighestLevel> highestLevels = [];

  init() async {
    final resSkill = ref.read(skillProvider);
    final resL = ref.read(locationsProvider);
    final resH = ref.read(highestLevelProvider);
    final resI = ref.read(interestProvider);
    if (resL != null) {
      setState(() {
        locations = resL;
      });
    } else {
    }
    if (resH != null) {
      setState(() {
        highestLevels = resH;
      });
    } else {
    }
    if (resSkill != null) {
      setState(() {
        skills = resSkill;
      });
    } else {
    }
    if (resI != null) {
      setState(() {
        interests = resI;
      });
    } else {
    }
  }

  int selectedLocation = 0;
  int selectedEducationLevel = 0;
  DateTime? selectedDate;
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title: Text(
          'Hi ${user?.firstName}👋',
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personal Details',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _idNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ID Number',
                  prefixIcon: const Icon(Icons.credit_card),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your ID number';
                  } else if (value.length > 8 && value.length < 7) {
                    return "Enter a valid ID number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _locationController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: const Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a location' : null,
                errorBuilder: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  List<Location> suggestions = [];
                  for (Location location in locations) {
                    if (location.name
                        .toLowerCase()
                        .contains(pattern.toLowerCase())) {
                      suggestions.add(location);
                    }
                  }
                  return suggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    selectedLocation = suggestion.id;
                  });
                  _locationController.text = suggestion.name.toString();
                },
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Education Details',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _educationLevelController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: 'Education Level',
                    prefixIcon: const Icon(Icons.school),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select education level' : null,
                errorBuilder: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  List<HighestLevel> suggestions = [];
                  for (HighestLevel level in highestLevels) {
                    if (level.name
                        .toLowerCase()
                        .contains(pattern.toLowerCase())) {
                      suggestions.add(level);
                    }
                  }
                  return suggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    selectedEducationLevel = suggestion.id;
                  });
                  _educationLevelController.text = suggestion.name.toString();
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _schoolNameController,
                decoration: InputDecoration(
                  labelText: 'School Name',
                  prefixIcon: const Icon(Icons.school),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _completionYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Year of Completion',
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.length != 4) {
                    return 'Please enter a valid year';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Select Skills',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _buildSkillChips(),
              ),
              const SizedBox(height: 10.0),
              TypeAheadFormField<Skill>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: skillController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: 'Skills',
                    prefixIcon: const Icon(Icons.work),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                // validator: (value) => selectedSkills.length < 4
                //     ? 'Please select at least four skills'
                //     : null,
                errorBuilder: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  List<Skill> suggestions = [];
                  for (Skill skill in skills) {
                    if (skill.skill
                        .toLowerCase()
                        .contains(pattern.toLowerCase())) {
                      suggestions.add(skill);
                    }
                  }
                  return suggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.skill,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    if (!selectedSkills.contains(suggestion)) {
                      selectedSkills.add(suggestion);
                    }
                  });
                  skillController.clear();
                },
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Work Interests',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _buildWorkInterestChips(),
              ),
              const SizedBox(height: 10.0),
              TypeAheadFormField<Interest>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: workInterestController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: 'Work interests',
                    prefixIcon: const Icon(Icons.work),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                // validator: (value) => selectedInterests.length < 4
                //     ? 'Please select at least four interests'
                //     : null,
                errorBuilder: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  List<Interest> suggestions = [];
                  for (Interest interest in interests) {
                    if (interest.interest
                        .toLowerCase()
                        .contains(pattern.toLowerCase())) {
                      suggestions.add(interest);
                    }
                  }
                  return suggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.interest,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    if (!selectedInterests.contains(suggestion)) {
                      selectedInterests.add(suggestion);
                    }
                  });
                  workInterestController.clear();
                },
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: pickFile,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: pickedResumes == null
                      ? const Column(
                          children: [
                            Icon(Icons.upload_file, size: 48.0),
                            SizedBox(height: 16.0),
                            Text(
                              'Resume Upload',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.upload_file_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: Text(
                                pickedResumes!.name,
                                style: TextStyles.normal(20),
                              ),
                            )
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        content: SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    );

                    final item = ProfileItem(

                      resume: base64Resume ?? "",
                      school: _schoolNameController.text.trim(),
                      dateOfBirth: _dobController.text,
                      highestLevelId: selectedEducationLevel,
                      idNumber: _idNumberController.text.trim(),
                      interestId: selectedInterests
                          .map((skill) => skill.id.toString())
                          .toList(),
                      locationId: selectedLocation,
                      skillId: selectedSkills
                          .map((skill) => skill.id.toString())
                          .toList(),
                      yearOfCompletion: _completionYearController.text.trim(),
                      // Include the picked resume file in the ProfileItem
                      resumeFile: pickedResumes,
                    );


                    ref.watch(profileItemsControllerProvider).postProfileItems(
                          context: context,
                          item: item,
                          token:
                              ref.read(userTokenProvider.notifier).state ?? '',
                        );
                  }

                },
                style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor, // Bolt app's button color
                ),
                child: const Text('Submit Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Skill> skills = [];
  List<Interest> interests = [];

  final List<Skill> selectedSkills = [];
  final List<Interest> selectedInterests = [];

  final TextEditingController skillController = TextEditingController();
  final TextEditingController workInterestController = TextEditingController();

  int selectedCount = 0;

  List<Widget> _buildSkillChips() {
    List<Widget> chips = [];

    for (Skill skill in selectedSkills) {
      final chip = InputChip(
        label: Text(skill.skill),
        onDeleted: () {
          setState(() {
            selectedSkills.remove(skill);
          });
        },
        selectedColor: AppColors.secondaryColor,
        selectedShadowColor: Colors.transparent,
        backgroundColor: AppColors.primaryColor,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
      );
      chips.add(chip);
    }

    return chips;
  }

  List<Widget> _buildWorkInterestChips() {
    List<Widget> chips = [];

    for (Interest interest in selectedInterests) {
      final chip = InputChip(
        label: Text(interest.interest),
        onDeleted: () {
          setState(() {
            selectedInterests.remove(interest);
          });
        },
        selectedColor: AppColors.secondaryColor,
        selectedShadowColor: Colors.transparent,
        backgroundColor: AppColors.primaryColor,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
      );
      chips.add(chip);
    }

    return chips;
  }
  PlatformFile? pickedResumes;
  // Store the base64 string

  pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf','doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedResumes = result.files.first;
      });

      // Convert file to base64 string
      File file = File(pickedResumes!.path!);
      List<int> fileBytes = await file.readAsBytes();
      String encodedFile = base64Encode(fileBytes);

      setState(() {
        base64Resume = encodedFile;
      });
    }
  }
}
