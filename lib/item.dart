import 'package:meta/meta.dart';

class Item {
  static final String tblItem         = "items";
  static final String colItemId       = "item_id";
  static final String colImageName    = "image_name";
  static final String colTypeCategory = "typecategory";
  static final String colCategory     = "category";
  static final String colColor        = "color";
  static final String colOwned        = "owned";

  int itemId;
  //List<int> outfitIds;
  String imageName, typeCategory, category, color;
  bool owned;

  Item({
    this.itemId,
    this.imageName,
    this.typeCategory,
    this.category,
    this.color,
    this.owned,
  });

  Item.fromMap(Map<String, dynamic> map): this(
    itemId       : map[colItemId],
    imageName    : map[colImageName],
    typeCategory : map[colTypeCategory],
    category     : map[colCategory],
    color        : map[colColor],
    owned        : map[colOwned] == 1,
  );

  Map toMap() {
    return {
      colItemId:       itemId,
      colImageName:    imageName,
      colTypeCategory: typeCategory,
      colCategory:     category,
      colColor:        color,
      colOwned:        owned == true ? 1 : 0,
    };
  }
}
