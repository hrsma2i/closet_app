import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/outfit.dart';



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
          CREATE TABLE ${Item.tblItem} ( 
            ${Item.colItemId}       INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Item.colImageName}    TEXT NOT NULL,
            ${Item.colTypeCategory} TEXT NOT NULL,
            ${Item.colCategory}     TEXT NOT NULL,
            ${Item.colColor}        TEXT NOT NULL,
            ${Item.colOwned}        INTEGER NOT NULL
          );
          '''
        );
        txn.rawInsert(
          '''
          INSERT INTO ${Item.tblItem}(
            ${Item.colItemId},
            ${Item.colImageName},
            ${Item.colTypeCategory},
            ${Item.colCategory},
            ${Item.colColor},
            ${Item.colOwned} )
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

    List<Item> items = new List();
    for (Map<String, dynamic> item in result) {
      var myItem = new Item.fromMap(item);
      items.add(myItem);
    }
    return items;
  }

  Future updateItem(Item item) async {
    await db.transaction((txn) async {
      await txn.rawInsert(
        """
        INSERT OR REPLACE INTO ${Item.tblItem}(
          ${Item.colItemId},
          ${Item.colImageName},
          ${Item.colInsulation},
          ${Item.colRemovable},
          ${Item.colTypeCategory},
          ${Item.colCategory},
          ${Item.colColor},
          ${Item.colOwned}
        ) VALUES (
          ${item.itemId},
          "${item.imageName}",
          ${item.insulation},
          ${item.removable?1:0},
          "${item.typeCategory}",
          "${item.category}",
          "${item.color}",
          ${item.owned?1:0}
        );
        """
      );
    });
  }

  Future<List<Outfit>> getOutfits(sql) async {
    var db = await _getDb();
    var result = await db.rawQuery(sql);

    List<Outfit> outfits = new List();
    for (Map<String, dynamic> outfit in result) {
      var myOutfit = new Outfit.fromMap(outfit);
      outfits.add(myOutfit);
    }
    return outfits;
  }

}
