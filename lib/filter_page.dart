import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/database.dart';
import 'package:closet_app/sql.dart';
import 'package:closet_app/typedef.dart';

class Condition {
  String key;
  String value;
}

class FilterPage extends StatefulWidget {
  final QueryNameUpdater updateQueryName;
  @override

  FilterPage(this.updateQueryName);

  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {

  String category;
  String queryName = "";
  final List<Condition> conditions = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Column(
        children: <Widget>[
          Text("category"),
          TextField(
            onChanged: (text){
              setState(() {
                category = text.toLowerCase();
              });
              String sql = """
              SELECT * FROM ${Item.tblItem}
              WHERE ${Item.tblItem}.${Item.colCategory} == $category;
              """;
              Navigator.pop(context, sql);
            },
          ),
        ],
      ),
    );
  }
}

