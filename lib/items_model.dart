import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/database.dart';

class ItemsModel extends Model {
  final List<Item> items = new List();

  //List<Item> get items => _items;

  void updateItemsByQuery(String sql) {
    print('updateItemsByQuery');
    ClosetDatabase.get()
      .getItems(sql)
      .then((items) {
          updateItems(items);
        }
      );
  }

  void updateItems(List<Item> newItems) {
    items.clear();
    items.addAll(newItems);
    notifyListeners();
  }

  void updateItem(Item newItem) {
    var oldItem = items.firstWhere((item) =>
    item.itemId == newItem.itemId);
    var replaceIndex = items.indexOf(oldItem);
    items.replaceRange(replaceIndex, replaceIndex+1, [newItem]);
    notifyListeners();
  }

  Item getItemById(int itemId) {
    return items.firstWhere((item) => item.itemId == itemId);
  }
}

