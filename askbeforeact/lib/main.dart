import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/home/landing_screen.dart';
import 'views/analysis/analyze_screen.dart';
import 'views/education/education_screen.dart';
import 'views/community/community_screen.dart';
import 'views/home/dashboard_screen.dart';

void main() {
  runApp(const AskBeforeActApp());
}

class AskBeforeActApp extends StatelessWidget {
  const AskBeforeActApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AskBeforeAct - AI Fraud Detection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingScreen(),
      routes: {
        '/analyze': (context) => const AnalyzeScreen(),
        '/education': (context) => const EducationScreen(),
        '/community': (context) => const CommunityScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
