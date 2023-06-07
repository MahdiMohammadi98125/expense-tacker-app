import 'package:flutter/material.dart';
// screen
import './screens/category_screen.dart';
import 'package:provider/provider.dart';
import './models/database_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DatabaseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: CategoryScreen.name,
      routes: {
        CategoryScreen.name: (_) => const CategoryScreen(),
      },
    );
  }
}
