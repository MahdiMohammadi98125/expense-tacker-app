import 'package:flutter/material.dart';
import '../widgets/expense_form.dart';
import '../widgets/category_screen/category_fetcher.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  static const name = './category_screen.dart'; // for routes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("categories"),
      ),
      body: const CategoryFetcher(),
      floatingActionButton: FloatingActionButton(
        onPressed: showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => ExpenseForm(),
        ),
      ),
    );
  }
}
