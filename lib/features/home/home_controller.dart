import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fursaapp/features/auth/controller/auth_controller.dart';

import '../../constants/constants.dart';
import '../../widgets/notifications.dart';
import '../auth/screens/delete_account_screen.dart';
import '../job_landing_screen.dart';
import '../my_jobs_screen.dart';
import '../user_profile_screen.dart';

class HomeController extends ConsumerStatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends ConsumerState<HomeController> {
  int currentIndex = 0;

  List<Widget> pages = [
    JobLandingScreen(),
    MyJobsPage(),
    ProfilePage(),
    // DeleteAccountPage()
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void pageController(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final initials = user.firstName.isNotEmpty && user.lastName.isNotEmpty
        ? '${user.firstName[0]}${user.lastName[0]}'
        : '';

    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.primaryColor,
          ),
          onPressed: openDrawer, // Open the drawer on menu icon tap
        ),
        centerTitle: true,
        title: Text(
          'Hi ${user.firstName}👋',
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsScreen()),
                    );
                  },
                  icon: const Icon(Icons.notifications,
                      color: AppColors.secondaryColor),
                ),
                CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 16,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    initials,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: pages[currentIndex],
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Text(
                'Hi ${user.firstName} 👋',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                pageController(0); // Set the selected page to Home
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('My Applications'),
              onTap: () {
                pageController(1); // Set the selected page to My Applications
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                pageController(2); // Set the selected page to Profile
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever_sharp,
                color: Colors.red,
              ),
              title: const Text('Delete Account'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the DeleteAccountPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeleteAccountPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.secondaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: pageController,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'My Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
