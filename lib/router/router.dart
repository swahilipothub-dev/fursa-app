import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fursaapp/features/job_landing_screen.dart';
import 'package:fursaapp/features/auth/screens/login_screen.dart';
import 'package:fursaapp/features/home/home_controller.dart';
import 'package:fursaapp/features/onboarding_screen.dart';
import 'package:fursaapp/features/auth/screens/profile_screen.dart';

import '../features/splash_screen.dart';

class AppRouter {
  static _route(Widget page, String route) {
    return CupertinoPageRoute(
      title: route,
      builder: (context) {
        return page;
      },
    );
  }

  //declare the route here with the route name and path
  static const String splashScreenRoute = "/splash";
  static const String onboarding = "/onboarding";
  static const String login = "/login";
  static const String jobLanding = "/jobLanding";
  static const String userDetails = "/userDetails";
  static const String homeController = "/homeController";
  static const String resetPassword = "/resetPassword";

  //add another case here,for the declared route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreenRoute:
        return _route(
          const SplashScreen(),
          splashScreenRoute,
        );

      case onboarding:
        return _route(
          const OnboardingScreen(),
          onboarding,
        );
      case login:
        return _route(
          const LoginScreen(),
          login,
        );
      case jobLanding:
        return _route(
          const JobLandingScreen(),
          jobLanding,
        );
      case userDetails:
        return _route(
          const UserDetailsForm(),
          userDetails,
        );
      case homeController:
        return _route(
          const HomeController(),
          homeController,
        );
      default:
        return _route(
          Scaffold(
            appBar: AppBar(
              title: const Text('Fursa App'),
            ),
            body: const Center(
              child: Text('Unknown page'),
            ),
          ),
          "unknown",
        );
    }
  }
}
