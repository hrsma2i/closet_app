import 'package:meta/meta.dart';


class Outfit {
  static final String tblLink       = "links";
  static final String colOutfitId   = "outfit_id";
  // created column
  static final String colItemIds    = "item_ids";
  static final String colImageNames = "image_names";
  static final String colPossible   = "possible";
  static final String colMaxIns     = "max_insulation";
  static final String colMinIns     = "min_insulation";
  static final String colTempMin    = "temp_min";
  static final String colTempMax    = "temp_max";

  int outfitId;
  List<int> itemIds;
  List<String> imageNames;

  Outfit({
    this.outfitId,
    this.itemIds,
    this.imageNames,
  });


  Outfit.fromMap(Map<String, dynamic> map): this(
    outfitId: map[colOutfitId],
    itemIds : map[colItemIds]
                .split(",")
                .map<int>((id) => int.parse(id)).toList(),
    imageNames : map[colImageNames].split(","),
  );

  Map toMap() {
    //return {
    //  columnOutfitId:       outfitId,
    //  columnImageName:    imageName,
    //  columnTypeCategory: typeCategory,
    //  columnCategory:     category,
    //  columnColor:        color,
    //  columnOwned:        owned == true ? 1 : 0,
    //};
  }
}
