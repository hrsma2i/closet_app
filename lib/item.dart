import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Item {
  static final String tableItem          = "items";
  static final String columnItemId       = "item_id";
  static final String columnImageName    = "image_name";
  static final String columnTypeCategory = "typecategory";
  static final String columnCategory     = "category";
  static final String columnColor        = "color";
  static final String columnOwned        = "owned";

  int itemId;
  //List<int> outfitIds;
  String imageName, typeCategory, category, color;
  bool owned;

  Item.create(
    this.itemId,
    this.imageName,
    this.typeCategory,
    this.category,
    this.color,
    this.owned,
  );

  Item.update({@required this.itemId, imageName, typeCategory,
    category, color, owned}) {
    if (imageName != null) {
      this.imageName = imageName;
    }
    if (typeCategory != null) {
      this.typeCategory = typeCategory;
    }
    if (category != null) {
      this.category = category;
    }
    if (color != null) {
      this.color = color;
    }
    if (color != null) {
      this.color = color;
    }
  }

  Map toMap() {
    return {
      columnItemId:       itemId,
      columnImageName:    imageName,
      columnTypeCategory: typeCategory,
      columnCategory:     category,
      columnColor:        color,
      columnOwned:        owned == true ? 1 : 0,
    };
  }

  Item.fromMap(Map<String, dynamic> map)
    : this.update(
      itemId       : map[columnItemId],
      imageName    : map[columnImageName],
      typeCategory : map[columnTypeCategory],
      category     : map[columnCategory],
      color        : map[columnColor],
      owned        : map[columnOwned] == 1,
    );
}
