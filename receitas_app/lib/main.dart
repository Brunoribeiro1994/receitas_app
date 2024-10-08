// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/meal_controller.dart';
import 'views/meal_list_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MealController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.orange,
    );
    return MaterialApp(
      title: 'Receitas',
      theme: theme,
      home: const MealListView(),
    );
  }
}
