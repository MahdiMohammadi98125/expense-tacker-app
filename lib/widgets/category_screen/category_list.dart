import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/database_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      // get the categories
      var list = db.categories;
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) => ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(list[i].icon),
          ),
          title: Text(list[i].title),
          subtitle: Text('entries: ${list[i].entries}'),
          trailing: Text('${(list[i].totalAmount).toStringAsFixed(2)}'),
        ),
      );
    });
  }
}
