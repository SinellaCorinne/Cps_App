import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cps/providers/survey_provider.dart';
import 'package:app_cps/screens/home_screen.dart';
import 'package:app_cps/utils/app_theme.dart';

void main() {
  runApp(const SocialLinkBeninApp());
}

class SocialLinkBeninApp extends StatelessWidget {
  const SocialLinkBeninApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SurveyProvider()),
      ],
      child: MaterialApp(
        title: 'Social-Link Bénin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
