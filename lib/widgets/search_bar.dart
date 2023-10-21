import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fursaapp/models/job_model.dart';
import 'package:fursaapp/widgets/job_view_sheet.dart';
import 'package:fursaapp/widgets/set_filter_sheet.dart';

import '../constants/constants.dart';

class SearchBarRow extends StatefulWidget {
  final List<Jobs> jobs;
  const SearchBarRow({Key? key, required this.jobs}) : super(key: key);

  @override
  State<SearchBarRow> createState() => _SearchBarRowState();
}

class _SearchBarRowState extends State<SearchBarRow> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 3.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: searchController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onTapOutside: (event) {
                  final currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
              ),
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
                List<Jobs> suggestions = [];
                for (Jobs job in widget.jobs) {
                  if (job.title.toLowerCase().contains(pattern.toLowerCase())) {
                    suggestions.add(job);
                  }
                }
                return suggestions;
              },
              itemBuilder: (context, suggestion) {
                return Card(
                  // Build the card UI for a recent job
                  child: ListTile(
                    leading: const Image(
                      image: AssetImage('assets/fursa.png'),
                    ),
                    title: Text(suggestion.title),
                    subtitle: Text(suggestion.title),
                    trailing: TextButton(
                      onPressed: () {
                        showBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ApplyBottomSheet(
                                job: suggestion,
                              );
                            });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors
                            .secondaryColor, // Set the button text color to green
                      ),
                      child: const Text('Apply'),
                    ),
                    onTap: () {
                      // Handle job item tap
                    },
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                searchController.clear();
              },
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          elevation: 3.0,
          child: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter button tap
              showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const SetFilterSheet();
                  });
            },
          ),
        ),
      ],
    );
  }
}
