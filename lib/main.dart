import 'package:flutter/material.dart';
import 'package:habit_tracking_demo/pages/home.dart';
import 'package:habit_tracking_demo/theme/light_mode.dart';
import 'package:habit_tracking_demo/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracking Demo',
      home: const HomePage(),
      theme: lightMode,
    );
  }
}
