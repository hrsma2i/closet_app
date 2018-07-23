import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';
import 'dart:async';

final String tableItem = "item";
final String columnItemId = "item_id";
final String columnImageName = "image_name";
final String columnTypeCategory = "typecategory";
final String columnCategory = "category";
final String columnColor = "color";
final String columnOwned = "owned";


class Item {
  int itemId;
  //List<int> outfitIds;
  String imageName, typeCategory, category, color;
  bool owned;

  //Item(
  //  this.itemId,
  //  this.imageName,
  //  this.typeCategory,
  //  this.category,
  //  this.color,
  //  this.owned,
  //);

  Item();

  Item.fromMap(Map map) {
    itemId = map[columnItemId];
    imageName = map[columnImageName];
    typeCategory = map[columnTypeCategory];
    category = map[columnCategory];
    color = map[columnColor];
    owned = map[columnOwned] == 1;
  }
}


//class ItemProvider {
//  Database db;
//
//  Future open(String path) async {
//    db = await openDatabase(
//        path,
//        version: 1,
//        onCreate: (
//            Database db,
//            int version,
//            ) async {
//          await db.execute(
//              '''
//          CREATE TABLE $tableItem (
//            $columnId        INTEGER PRIMARY KEY AUTOINCREMENT,
//            $columnImageName TEXT NOT NULL,
//            $columnTypeCategory
//          )
//          '''
//          )
//        }
//    );
//  }
//}

List<Map> itemMaps = [
  {
    columnItemId:       0,
    columnImageName:    './images/shirtshalf_aloha.PNG',
    columnTypeCategory: 'tops',
    columnCategory:     'half sleeve shirts',
    columnColor:        "grey",
    columnOwned:        1,
  },
  {
    columnItemId:       1,
    columnImageName:    './images/denim_indigo.PNG',
    columnTypeCategory: 'pants',
    columnCategory:     'denim pants',
    columnColor:        "blue",
    columnOwned:        1,
  },
  {
    columnItemId:       2,
    columnImageName:    './images/dress_shoes_black_martens.PNG',
    columnTypeCategory: 'shoes',
    columnCategory:     'dress shoes',
    columnColor:        "black",
    columnOwned:        1,
  },
];

List<Item> items = itemMaps.map(
    (itemMap) => new Item.fromMap(itemMap)
);


class Outfit {
  List<Item> items;

  Outfit(this.items);
}


//List<Outfit> outfits = [
//  Outfit([
//    Item('./images/T_big_white.PNG',
//         'T-shirt','white'),
//    Item('./images/slucks_black.PNG',
//         'slucks','black'),
//    Item('./images/dress_shoes_black_martens.PNG',
//         'dress shoes','black'),
//  ]),
//  Outfit([
//    Item('./images/shirtshalf_aloha.PNG',
//        'half sleeve shirts','grey'),
//    Item('./images/denim_indigo.PNG',
//        'denim pants','blue'),
//    Item('./images/dress_shoes_black_martens.PNG',
//        'dress shoes','black'),
//    Item('./images/dress_shoes_black_martens.PNG',
//        'dress shoes','black'),
//    Item('./images/dress_shoes_black_martens.PNG',
//        'dress shoes','black'),
//  ]),
//];

//List<Item> items = outfits.expand(
//  (outfit) => outfit.items
//).toList();
//
//List<Widget> itemImages = items.map(
//  (item) => Image(image: AssetImage(item.imageFile)),
//).toList();
//
//List<Widget> outfitImages = outfits.map(
//  (outfit) => GridView.count(
//    primary: false,
//    padding: const EdgeInsets.all(0.0),
//    crossAxisSpacing: 10.0,
//    crossAxisCount: sqrt(outfit.items.length).ceil(),
//    children: outfit.items.map(
//      (item) => Image(image: AssetImage(item.imageFile))
//    ).toList(),
//  )
//).toList();