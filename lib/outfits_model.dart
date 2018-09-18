import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/outfit.dart';
import 'package:closet_app/database.dart';

class OutfitsModel extends Model {
  final List<Outfit> outfits = new List();

  //List<Outfit> get outfits => _outfits;

  void updateOutfitsByQuery(String sql) {
    print('updateOutfitsByQuery');
    ClosetDatabase.get()
      .getOutfits(sql)
      .then((outfits) {
          updateOutfits(outfits);
        }
      );
  }

  void updateOutfits(List<Outfit> newOutfits) {
    outfits.clear();
    outfits.addAll(newOutfits);
    notifyListeners();
  }

  void updateOutfit(Outfit newOutfit) {
    var oldOutfit = outfits.firstWhere((outfit) =>
      outfit.outfitId == newOutfit.outfitId);
    var replaceIndex = outfits.indexOf(oldOutfit);
    outfits.replaceRange(replaceIndex, replaceIndex+1, [newOutfit]);
    notifyListeners();
  }

  Outfit getOutfitById(int outfitId) {
    return outfits.firstWhere((outfit) => outfit.outfitId == outfitId);
  }
}

