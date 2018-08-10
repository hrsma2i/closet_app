import 'package:meta/meta.dart';

class Item {
  static final String tblItem         = "items";
  static final String colItemId       = "item_id";
  static final String colImageName    = "image_name";
  static final String colInsulation   = "insulation";
  static final String colRemovable    = "removable";
  static final String colTypeCategory = "typecategory";
  static final String colCategory     = "category";
  static final String colColor        = "color";
  static final String colOwned        = "owned";

  static final String tblCategoryHow = "category_how";
  static final String colHow = "how";

  int itemId, insulation;
  //List<int> outfitIds;
  String imageName, typeCategory, category, color;
  bool owned, removable;

  Item({
    this.itemId,
    this.imageName,
    this.insulation,
    this.removable,
    this.typeCategory,
    this.category,
    this.color,
    this.owned,
  });

  Item.fromMap(Map<String, dynamic> map): this(
    itemId       : map[colItemId],
    imageName    : map[colImageName],
    insulation   : map[colInsulation],
    removable    : map[colRemovable] == 1,
    typeCategory : map[colTypeCategory],
    category     : map[colCategory],
    color        : map[colColor],
    owned        : map[colOwned] == 1,
  );

  Map toMap() {
    return {
      colItemId:       itemId,
      colImageName:    imageName,
      colInsulation:   insulation,
      colRemovable:    removable == true ? 1 : 0,
      colTypeCategory: typeCategory,
      colCategory:     category,
      colColor:        color,
      colOwned:        owned == true ? 1 : 0,
    };
  }
}
