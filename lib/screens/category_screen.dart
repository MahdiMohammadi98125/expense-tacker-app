import 'package:flutter/material.dart';

class categoryScreen extends StatelessWidget {
  const categoryScreen({super.key});
  static const name = '/category_screen'; // for routes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("categories"),
      ),
    );
  }
}
