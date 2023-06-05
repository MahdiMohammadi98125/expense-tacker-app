import 'package:flutter/material.dart';
import '../constants/icons.dart';

class ExpenseCategory {
  final String title;
  int entries = 0;
  double totalAmount = 0.0;
  final IconData icon;

  // constructor
  ExpenseCategory(
      {required this.title,
      required this.entries,
      required this.totalAmount,
      required this.icon});
// we need a method to convert this model to map
// so that we can insert it into a database
  Map<String, dynamic> toMap() => {
        'title': title,
        'entries': entries,
        // our DB can't store double value so we convert it to a string
        'totalAmount': totalAmount.toString()
      };

  // when we retrieve the data from the database it will be a map.
  // for our app to understand the data we need to convert it back to Expense Category.
  factory ExpenseCategory.fromString(Map<String, dynamic> value) =>
      ExpenseCategory(
          title: value['title'],
          entries: value['entries'],
          totalAmount: double.parse(value['totalAmount']),
          // it will search the icons map and find the value related to the title.
          icon: icons[value['title']]!);
}
