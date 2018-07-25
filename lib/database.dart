import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:closet_app/item.dart';

import 'package:flutter/services.dart';


class ClosetDatabase {
  static final ClosetDatabase _closetDatabase = new ClosetDatabase._internal();

  Database db;

  bool didInit = false;

  static ClosetDatabase get(){
    print('get');
    return _closetDatabase;
  }

  Future<Database> _getDb() async {
    if (!didInit) await init();
    return db;
  }

  ClosetDatabase._internal();

  Future init() async {
    print('init');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //String path = join(documentsDirectory.path, "closet.db");
    //-----------sample db---------------------
    String path = join(documentsDirectory.path, "asset_example.db");
    await deleteDatabase(path);
    ByteData data = await rootBundle.load("example.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    //-----------sample db---------------------
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          print('onCreate');
          //await _createItemTable(db);
        },
    );
    didInit = true;
  }

  Future _createItemTable(Database db) {
    print('_createItemTable');
    return db.transaction(
      (Transaction txn) async {
        txn.execute(
          '''
          CREATE TABLE ${Item.tableItem} ( 
            ${Item.columnItemId}       INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Item.columnImageName}    TEXT NOT NULL,
            ${Item.columnTypeCategory} TEXT NOT NULL,
            ${Item.columnCategory}     TEXT NOT NULL,
            ${Item.columnColor}        TEXT NOT NULL,
            ${Item.columnOwned}        INTEGER NOT NULL
          );
          '''
        );
        txn.rawInsert(
          '''
          INSERT INTO ${Item.tableItem}(
            ${Item.columnItemId},
            ${Item.columnImageName},
            ${Item.columnTypeCategory},
            ${Item.columnCategory},
            ${Item.columnColor},
            ${Item.columnOwned} )
          VALUES(
            0,
            "./images/dress_shoes_black_martens.PNG",
            "shoes",
            "dress shoes",
            "black",
            1);
          ''',
        );
      }
    );
  }

  Future<List<Item>> getItems(sql) async {
    var db = await _getDb();
    var result = await db.rawQuery(sql);
    print(result);

    List<Item> items = new List();
    for (Map<String, dynamic> item in result) {
      var myItem = new Item.fromMap(item);
      items.add(myItem);
    }
    return items;
  }

}


//List<Map> itemMaps = [
//  {
//    columnItemId:       0,
//    columnImageName:    './images/shirtshalf_aloha.PNG',
//    columnTypeCategory: 'tops',
//    columnCategory:     'half sleeve shirts',
//    columnColor:        "grey",
//    columnOwned:        1,
//  },
//  {
//    columnItemId:       1,
//    columnImageName:    './images/denim_indigo.PNG',
//    columnTypeCategory: 'pants',
//    columnCategory:     'denim pants',
//    columnColor:        "blue",
//    columnOwned:        1,
//  },
//  {
//    columnItemId:       2,
//    columnImageName:    './images/dress_shoes_black_martens.PNG',
//    columnTypeCategory: 'shoes',
//    columnCategory:     'dress shoes',
//    columnColor:        "black",
//    columnOwned:        1,
//  },
//];
