import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../state/student_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/shell.dart';
import 'screens/splash_screen.dart';

class StudentGuideApp extends StatelessWidget {
  const StudentGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    return MaterialApp(
      title: 'Student Guide',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: state.themeMode,
      home: !state.loaded
          ? const SplashScreen()
          : state.profile.onboardingComplete
              ? const AppShell()
              : const OnboardingScreen(),
    );
  }
}
