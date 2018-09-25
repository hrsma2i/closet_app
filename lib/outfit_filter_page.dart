import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/outfit.dart';
import 'package:closet_app/database.dart';
import 'package:closet_app/sql.dart';


//class ConditionModel extends Model {
//  String colorName;
//  String typecategory;
//  bool owned;
//
//  ConditionModel(this.colorName, this.typecategory, this.owned);
//
//  String getSql() {
//
//    List<String> sqlParts = new List();
//
//    if ((colorName != null)
//        || (typecategory != null)
//        || (owned != null)) {
//      sql += "WHERE ";
//    }
//    if (colorName != null) {
//      sqlParts.add("""
//        ${Item.tblItem}.${Item.colColor} = "$colorName"
//      """);
//    }
//    if (typecategory != null) {
//      sqlParts.add("""
//        ${Item.tblItem}.${Item.colTypeCategory} = "$typecategory"
//      """);
//    }
//    if (owned != null) {
//      sqlParts.add("""
//        ${Item.tblItem}.${Item.colOwned} = ${owned?1:0}
//      """);
//    }
//    sql += sqlParts.join("AND") + ";";
//
//    return sql;
//  }
//}

class OutfitFilterPage extends StatefulWidget {
  @override
  OutfitFilterPageState createState() => OutfitFilterPageState();
}

class OutfitFilterPageState extends State<OutfitFilterPage> {
  ItemsRow rowIncluded = ItemsRow();
  ItemsRow rowExcluded = ItemsRow();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Outfit Filter'),
      ),
      body: Column(
        children: <Widget>[
          Header(
            title: 'Include',
            color: Colors.red[400],
          ),
          rowIncluded,
          Divider(),
          Header(
            title: 'Exclude',
            color: Colors.blue[400],
          ),
          rowExcluded,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        heroTag: null,
        onPressed: () {
          String sql = getSql();
          print(sql);
          Navigator.pop(context, sql);
        }
      ),
    );
  }

  String getSql() {
    String sqlIncluded = rowIncluded.items.map((item) =>
      "${Item.colItemId} == ${item.itemId}"
    ).toList().join('\n AND ');
    String sqlExcluded = rowExcluded.items.map((item) =>
    "${Item.colItemId} == ${item.itemId}"
    ).toList().join('\n AND ');

    String sql = """
      SELECT ${Outfit.colOutfitId},
             ${Outfit.colItemIds},
             ${Outfit.colImageNames}
      FROM(
        SELECT ${Outfit.colOutfitId},
          GROUP_CONCAT(${Item.tblItem}.${Item.colItemId}   , ',')
            AS ${Outfit.colItemIds},
          GROUP_CONCAT(${Item.tblItem}.${Item.colImageName}, ',')
            AS ${Outfit.colImageNames}
        FROM ${Outfit.tblLink}
          INNER JOIN ${Item.tblItem}
            ON ${Outfit.tblLink}.${Item.colItemId}
             = ${Item.tblItem}.${Item.colItemId}
        GROUP BY ${Outfit.tblLink}.${Outfit.colOutfitId}
      )
      WHERE """;

    if (rowIncluded.items.isNotEmpty) {
      sql +="""
        ${Outfit.colOutfitId} IN (
          SELECT ${Outfit.colOutfitId}
          FROM ${Outfit.tblLink}
          WHERE """;
      sql += sqlIncluded;
      sql += ")";
    }
    if (rowExcluded.items.isNotEmpty) {
      if (rowIncluded.items.isNotEmpty) {
        sql += "\n AND ";
      }
      sql +="""
        ${Outfit.colOutfitId} NOT IN (
          SELECT ${Outfit.colOutfitId}
          FROM ${Outfit.tblLink}
          WHERE """;
      sql += sqlExcluded;
      sql += ")";
    }
    sql += ";";

    return sql;
  }
}


class Header extends StatelessWidget {
  String title;
  Color color;

  Header({this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Card(
        color: color,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 20.0,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        //onPressed: (){},
      ),
    );
  }
}


class ItemsRow extends StatefulWidget {
  List<Item> items = List();

  ItemsRow();

  @override
  ItemsRowState createState() {
    return ItemsRowState();
  }
}


class ItemsRowState extends State<ItemsRow> {

  @override
  void initState(){

    //---example----
    ClosetDatabase.get()
      .getItems(sqlMapItem['to buy'])
      .then((items) {
        setState(() {
          widget.items = items;
        });
      });
    //---example----

    super.initState();
  }

  void deleteItem(item) {
    setState(() {
      widget.items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemCards = widget.items.map<Widget>((item) =>
      ItemCard(
        item:item,
        deleteCallback: deleteItem,
      )
    ).toList();

    itemCards.add(AddButton());

    return Container(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        children: itemCards.reversed.toList(),
      ),
    );
  }
}


class AddButton extends StatelessWidget {
  String title;
  Color color;

  AddButton({this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      width: 160.0,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: IconButton(
          icon: Icon(Icons.add),
          iconSize: 50.0,
          color: Theme.of(context).dividerColor,
          onPressed: (){},
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
    );
  }
}


class ItemCard extends StatelessWidget {
  Item item;
  Function deleteCallback;

  ItemCard({this.item, this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Stack(
          children: <Widget>[
            Image.asset(
                join('images', item.imageName)
            ),
            deleteButton(),
          ],
        ),
      )
    );
  }

  Widget deleteButton() {
    return Container(
      height: 30.0,
      width: 30.0,
      alignment: Alignment.center,
      child: FloatingActionButton(
        heroTag: null,
        foregroundColor: Color(0xAAFFFFFF),
        backgroundColor: Color(0x88444444),
        child: Icon(Icons.clear),
        elevation: 0.0,
        onPressed: (){
          deleteCallback(item);
        },
      ),
    );
  }
}

