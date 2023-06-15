// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/icons.dart';
import './ex_category.dart';
import './expense.dart';

class DatabaseProvider with ChangeNotifier {
  // in-app memory for holding the Expense categories temporarily
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  List<Expense> _expenses = [];
  List<Expense> get expenses => expenses;

  Database? _database;
  Future<Database> get database async {
    // database directory
    final dbDictionary = await getDatabasesPath();
    // database name
    const dbName = 'expense_tc.db';
    // full path
    final path = join(dbDictionary, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return _database!;
  }

  // _createDb function
  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';
  Future<void> _createDb(Database db, int version) async {
    // this method runs only once. when the database is being created

    await db.transaction((txn) async {
      // category table
      await txn.execute('''CREATE TABLE $cTable(
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
      )''');
      // expense table
      await txn.execute('''CREATE TABLE $eTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT,
        category TEXT
      )''');

      // insert the initial categories.
      // this will add all the categories to category table and initialize the 'entries' with 0 and 'totalAmount' to 0.0
      for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }
    });
  }

  // method to fetch categories
  Future<List<ExpenseCategory>> fetchCategories() async {
    // get the database
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(cTable).then((data) {
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<ExpenseCategory> nList = List.generate(converted.length,
            (index) => ExpenseCategory.fromString(converted[index]));
        _categories = nList;
        return _categories;
      });
    });
  }
}

Future<void> updateCategory(
  String category,
  int nEntries,
  double nTotalAmount,
) async {
  final db = await database;
  await db.transaction((txn) async {
    await txn
        .update(
      cTable, // category table
      {
        'entries': nEntries, // new value of 'entries'
        'totalAmount': nTotalAmount.toString(), // new value of 'totalAmount'
      },
      where: 'title == ?', // in table where the title ==
      whereArgs: [category], // this category.
    )
        .then((_) {
      // after updating in database. update it in our in-app memory too.
      var file = _categories.firstWhere((element) => element.title == category);
      file.entries = nEntries;
      file.totalAmount = nTotalAmount;
      notifyListeners();
    });
  });
}

// method to add an expense to database

Future<void> addExpense(Expense exp) async {
  final db = await Database;
  await db.transaction((txn) async {
    await txn
        .insert(
      eTable,
      exp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((generatedId) {
      // after inserting in a database. we store it in in-app memory with new expense with generated id
      final file = Expense(
          id: generatedId,
          title: exp.title,
          amount: exp.amount,
          date: exp.date,
          category: exp.category);
      // add it to '_expenses'

      _expenses.add(file);
      // notify the listeners about the change in value of '_expenses'
      notifyListeners();
      // after we inserted the expense, we need to update the 'entries' and 'totalAmount' of the related 'category'
      var ex = findCategory(exp.category);

      updateCategory(exp.category, ex.entries + 1, ex.totalAmount + exp.amount);
    });
  });
}

ExpenseCategory findCategory(String title) {
  return _categories.firstWhere((element) => element.title == title);
}

Map<String, dynamic> calculateEntriesAndAmount(String category) {
  double total = 0.0;
  var list = _expenses.where((element) => element.category == category);
  for (final i in list) {
    total += i.amount;
  }
  return {'entries': list.length, 'totalAmount': total};
}
