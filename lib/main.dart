import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:fursaapp/features/splash_screen.dart';
import 'package:fursaapp/router/router.dart';
import 'package:fursaapp/theme.dart/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GeolocatorPlatform.instance;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
