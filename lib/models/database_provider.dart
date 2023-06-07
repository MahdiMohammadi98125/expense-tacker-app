import 'package:flutter/material.dart';
import '../constants/icons.dart';
import './ex_category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider with ChangeNotifier {
  // in-app memory for holding the Expense categories temporarily
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

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
