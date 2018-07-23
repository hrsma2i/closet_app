import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:closet_app/item.dart';


class AppDatabase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  Database _database;
  Database db;

  static AppDatabase get(){
    return _appDatabase;
  }

  bool didInit = false;

  Future<Database> _getDb() async {
    print('_getDb');
    if (!didInit) await _init();
    return _database;
  }

  Future _init() async {
    print('_init');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "closet.db");
    //_database = await openDatabase(
    _database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await _createItemTable(db);
        },
        //onUpgrade: (Database db, int oldVersion, int newVersion) async {
        //  await db.execute("DROP TABLE ${Item.tableItem}");
        //  await _createItemTable(db);
        //},
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
            ${Item.columnOwned},
          ) VALUES(
            0,
            "./images/dress_shoes_black_martens.PNG",
            "shoes",
            "dress shoes",
            "black",
            1,
          )
          ''',
        );
      }
    );
  }

  Future<List<Item>> getOwnedItems() async {
    print('getOwnedItems');
    Database db = await _getDb();

    var sql =
      '''
      SELECT * FROM ${Item.tableItem};
      ''';
    //WHERE ${Item.columnOwned} == 1;
    var result = await db.rawQuery(
      sql
    );
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
