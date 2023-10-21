import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fursaapp/features/results_filtered.dart';

import '../constants/constants.dart';

const List<String> list = <String>[
  'Software Engineering',
  'Construction',
  'Health',
  'Hospitality'
];
const List<String> locationList = <String>[
  'Mombasa City',
  'Nyali',
  'Likoni',
  'Kisauni',
  'Mtwapa',
  'Bamburi',
  'Shanzu',
  'Tudor',
  'Ganjoni',
  'Mikindani',
  'Changamwe',
  'Jomvu',
];
const List<String> jobTypeList = <String>[
  'Full-time',
  'Contract',
  'Part-time',
  'Casual'
];

class SetFilterSheet extends StatefulWidget {
  const SetFilterSheet({super.key});

  @override
  State<SetFilterSheet> createState() => _SetFilterSheetState();
}

class _SetFilterSheetState extends State<SetFilterSheet> {
  GlobalKey<AutoCompleteTextFieldState<String>> categoryKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> locationKey = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> jobTypeKey = GlobalKey();
  TextEditingController categoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController jobTypeController = TextEditingController();
  String selectedCategory = '';
  String selectedLocation = '';
  String selectedJobType = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Divider(height: 10, thickness: 10),
            const Text(
              'Set Filters',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skills',
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                ),
              ],
            ),
            AutoCompleteTextField<String>(
              key: categoryKey,
              controller: categoryController,
              clearOnSubmit: false,
              suggestions: list,
              decoration: const InputDecoration(
                hintText: 'Select a skill',
                border: OutlineInputBorder(),
              ),
              itemFilter: (item, query) {
                return item.toLowerCase().startsWith(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return a.compareTo(b);
              },
              itemSubmitted: (item) {
                setState(() {
                  selectedCategory = item;
                });
              },
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item),
                );
              },
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text('Location'),
              ],
            ),
            AutoCompleteTextField<String>(
              key: locationKey,
              controller: locationController,
              clearOnSubmit: false,
              suggestions: locationList,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select a location',
                border: OutlineInputBorder(),
              ),
              itemFilter: (item, query) {
                return item.toLowerCase().startsWith(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return a.compareTo(b);
              },
              itemSubmitted: (item) {
                setState(() {
                  selectedLocation = item;
                });
              },
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item),
                );
              },
            ),
            const SizedBox(height: 16),
            // const Row(
            //   children: [
            //     Text('Job Type'),
            //   ],
            // ),
            // AutoCompleteTextField<String>(
            //   key: jobTypeKey,
            //   controller: jobTypeController,
            //   clearOnSubmit: false,
            //   suggestions: jobTypeList,
            //   decoration: const InputDecoration(
            //     hintText: 'Select a job type',
            //     border: OutlineInputBorder(),
            //   ),
            //   itemFilter: (item, query) {
            //     return item.toLowerCase().startsWith(query.toLowerCase());
            //   },
            //   itemSorter: (a, b) {
            //     return a.compareTo(b);
            //   },
            //   itemSubmitted: (item) {
            //     setState(() {
            //       selectedJobType = item;
            //     });
            //   },
            //   itemBuilder: (context, item) {
            //     return ListTile(
            //       title: Text(item),
            //     );
            //   },
            // ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
              ),
              onPressed: () {
                // Do something when the button is pressed.
                showBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const FilteredResults();
                    });
              },
              child: const Text('Apply Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
