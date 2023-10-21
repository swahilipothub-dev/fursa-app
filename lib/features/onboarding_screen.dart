import 'package:flutter/material.dart';
import 'package:fursaapp/constants/constants.dart';
import 'package:fursaapp/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Find Your Dream Job',
      'description': 'Explore and apply for job opportunities in your field.',
      'image': 'assets/onboarding1.png',
    },
    {
      'title': 'Create Your Profile',
      'description':
          'Build a professional profile to showcase your skills and experience.',
      'image': 'assets/onboarding2.png',
    },
    {
      'title': 'Get Hired',
      'description': 'Connect with employers and land your dream job.',
      'image': 'assets/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return buildOnboardingPage(_onboardingData[index]);
              },
            ),
          ),
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => buildPageIndicator(index),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              onPressed: () {
                if (_currentPage == _onboardingData.length - 1) {
                  // Navigate to login screen
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  // Go to the next page
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
              buttonText: _currentPage == _onboardingData.length - 1
                  ? 'Get Started'
                  : 'Next',
              width: MediaQuery.of(context).size.width,
              height: 40,
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(Map<String, String> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            data['image']!,
            height: 500,
            width: 400,
          ),
        ),
        const SizedBox(height: 40.0),
        Text(
          data['title']!,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            data['description']!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildPageIndicator(int index) {
    return Container(
      width: 10.0,
      height: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.green : Colors.grey,
      ),
    );
  }
}
