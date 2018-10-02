import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/outfit.dart';
import 'package:closet_app/database.dart';
import 'package:closet_app/sql.dart';
import 'package:closet_app/item_gridview_page.dart';


class OutfitFilterPage extends StatefulWidget {
  String originalQuery;

  OutfitFilterPage({this.originalQuery});

  @override
  OutfitFilterPageState createState() => OutfitFilterPageState();
}

class OutfitFilterPageState extends State<OutfitFilterPage> {
  ItemsRow rowIncluded = ItemsRow();
  ItemsRow rowExcluded = ItemsRow();
  //----prototype----
  TextEditingController minCtrler = TextEditingController();
  TextEditingController maxCtrler = TextEditingController();
  //----prototype----

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

          //----prototype----
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 150.0,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "min temparature"
                  ),
                  keyboardType: TextInputType.number,
                  controller: minCtrler,
                ),
              ),
              Container(
                width: 150.0,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "max temparature"
                  ),
                  keyboardType: TextInputType.number,
                    controller: maxCtrler,
                ),
              ),
            ],
          ),
          //----prototype----

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        heroTag: null,
        onPressed: () {
          String sql = getSql(widget.originalQuery);
          print(sql);
          Navigator.pop(context, sql);
        }
      ),
    );
  }

  String getSql(String originalQuery) {
    print('getSql');

    String sqlIncluded = rowIncluded.items.map((item) =>
      "${Item.colItemId} == ${item.itemId}"
    ).toList().join('\n OR ');
    String sqlExcluded = rowExcluded.items.map((item) =>
    "${Item.colItemId} == ${item.itemId}"
    ).toList().join('\n OR ');

    String sql = """
      SELECT ${Outfit.colOutfitId},
             ${Outfit.colItemIds},
             ${Outfit.colImageNames}
      FROM(
        ${originalQuery.replaceAll(";", "")}
      )
      """;

    if (rowIncluded.items.isNotEmpty || rowExcluded.items.isNotEmpty) {
      sql += "WHERE ";
    }
    if (rowIncluded.items.isNotEmpty) {
      sql +="""
        ${Outfit.colOutfitId} IN (
          SELECT ${Outfit.colOutfitId}
          FROM(
            SELECT ${Outfit.colOutfitId},
              COUNT(${Item.colItemId}) AS num_items
            FROM ${Outfit.tblLink}
            WHERE """;
      sql += sqlIncluded;
      sql += """
            GROUP BY ${Outfit.colOutfitId}
          )
          WHERE num_items == ${rowIncluded.items.length}
      """;
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

    //----prototype----
    sql = sql.replaceAll('replacedTempMin', minCtrler.text);
    sql = sql.replaceAll('replacedTempMax', maxCtrler.text);
    //----prototype----

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
    //ClosetDatabase.get()
    //  .getItems(sqlMapItem['to buy'])
    //  .then((items) {
    //    setState(() {
    //      widget.items = items;
    //    });
    //  });
    //---example----
    widget.items = [];

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

    itemCards.add(AddButton(context));

    return Container(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        children: itemCards.reversed.toList(),
      ),
    );
  }

  Widget AddButton(BuildContext context) {
    return Container(
      height: 160.0,
      width: 160.0,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: IconButton(
          icon: Icon(Icons.add),
          iconSize: 50.0,
          color: Theme.of(context).dividerColor,
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                  ItemGrid(
                    queryName: 'owned',
                    selectable: true,
                  ),
                settings:  RouteSettings(
                  name: '/edit_filter',
                  isInitialRoute: false
                ),
              )
            ).then((items){
              setState(() {
                widget.items.addAll(items);
              });
            });
          },
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

