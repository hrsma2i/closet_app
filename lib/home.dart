import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:quiver/iterables.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/item.dart';
import 'package:closet_app/outfit.dart';

class HomeScreen extends StatelessWidget {
  static List<ItemTopTab> itemTopTabs = [
    ItemTopTab('owned'),
    ItemTopTab('to buy'),
    ItemTopTab('all'),
  ];

  static List<OutfitTopTab> outfitTopTabs = [
    OutfitTopTab('possible'),
    OutfitTopTab('all'),
  ];

  static List<Widget> bottomPages = [
    BottomPageWithTopTabs('Outfit', outfitTopTabs),
    BottomPageWithTopTabs('Items',  itemTopTabs),
    BottomPageWithTopTabs('Find',   itemTopTabs),
  ];

  static List<String> names = [
    'Outfit',
    'Items',
    'Find',
  ];

  static List<Widget> icons = [
    new ImageIcon(
      AssetImage('./icons/outfit_fill.png'),
    ),
    new ImageIcon(
      AssetImage('./icons/T_fill.png'),
    ),
    Icon(Icons.search),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomPageContainer(bottomPages, names, icons);
  }
}

class BottomPageContainer extends StatefulWidget {
  List<Widget> bottomPages;
  List<String> names;
  List<Widget> icons;

  BottomPageContainer(this.bottomPages, this.names, this.icons);
  @override
  BottomPageContainerState createState() =>
    new BottomPageContainerState(bottomPages, names, icons);
}

class BottomPageContainerState extends State<BottomPageContainer> {
  List<Widget> bottomPages;
  List<String> names;
  List<Widget> icons;

  int index = 0;

  BottomPageContainerState(this.bottomPages, this.names, this.icons);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: List<Offstage>.generate(
          bottomPages.length,
          (int i) => Offstage(
            offstage: index != i,
            child: new TickerMode(
              enabled: index == i,
              child: bottomPages[i]
            )
          )
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){},
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) { setState((){ this.index = index; }); },
        items: zip([icons, names]).map((icnm) =>
          new BottomNavigationBarItem(
            icon: icnm[0],
            title: new Text(icnm[1]),
          )
        ).toList(),
      ),
    );
  }
}


class BottomPageWithTopTabs extends StatelessWidget {
  String name;
  List<TopTab> topTabs;

  BottomPageWithTopTabs(this.name, this.topTabs);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: topTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          bottom: TabBar(
            tabs: topTabs.map(
                    (topTab) => new Tab(text: topTab.name)
            ).toList(),
          ),
        ),
        body: TabBarView(
          children: topTabs,
        ),
      ),
    );
  }
}

abstract class TopTab extends StatefulWidget {
  String name;

  State createState();
}

class ItemTopTab extends TopTab {
  String name;

  ItemTopTab(this.name);

  @override
  ItemTopTabState createState() => new ItemTopTabState(name);
}


class ItemTopTabState extends State<ItemTopTab> {
  String name;
  List<Widget> gridCells;

  ItemTopTabState(this.name);

  @override
  void initState(){
    super.initState();
    ClosetDatabase.get()
      .getItems(sqlMapItem[name])
      .then((items) {
          setState(() {
            //gridCells = items.map(
            //    (item) => Image(
            //    image: AssetImage(
            //        join('images', item.imageName)
            //    )
            //  ),
            //).toList();
            gridCells = items.map(
                  (item) => ItemCard(item)
            ).toList();
          });
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return gridCells != null
      ? new Padding(
        padding: EdgeInsets.all(2.5),
        child: GridView.count(
          primary: false,
          //padding: const EdgeInsets.all(2.5),
          crossAxisSpacing: 2.5,
          crossAxisCount: 3,
          children: gridCells,
        )
      )
      : new Container();
  }
}

class ItemCard extends StatelessWidget {
  Item item;

  ItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Image.asset(
          join('images', item.imageName)
        ),
      )
    );
  }
}

class OutfitTopTab extends TopTab {
  String name;

  OutfitTopTab(this.name);

  @override
  OutfitTopTabState createState() => new OutfitTopTabState(name);
}


class OutfitTopTabState extends State<OutfitTopTab> {
  String name;
  List<Widget> gridCells;

  OutfitTopTabState(this.name);

  @override
  void initState(){
    super.initState();
    ClosetDatabase.get()
        .getOutfits(sqlMapOutfit[name])
        .then((outfits) {
      setState(() {
        gridCells = outfits.map(
          (outfit) => OutfitCard(outfit)
        ).toList();
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return gridCells != null
      ? GridView.count(
        primary: false,
        padding: const EdgeInsets.all(5.0),
        crossAxisSpacing: 5.0,
        crossAxisCount: 2,
        children: gridCells,
      )
      : new Container();
  }
}

class OutfitCard extends StatelessWidget {
  Outfit outfit;

  OutfitCard(this.outfit);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: new GridView.count(
        primary: false,
        padding: const EdgeInsets.all(0.0),
        crossAxisSpacing: 0.0,
        crossAxisCount: sqrt(outfit.itemIds.length).ceil(),
        children: outfit.imageNames.map(
                (imageName) => new Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Image(
                  image: AssetImage(
                      join('images', imageName)
                  )
            ),
                )
        ).toList(),
      ),
    );
  }
}


Map<String, String> sqlMapItem = {
  'owned':
    '''
    SELECT * FROM ${Item.tblItem}
    WHERE ${Item.colOwned} == 1;
    ''',
  'to buy':
    '''
    SELECT * FROM ${Item.tblItem}
    WHERE ${Item.colOwned} == 0;
    ''',
  'all':
    '''
    SELECT * FROM ${Item.tblItem};
    ''',
};

Map<String, String> sqlMapOutfit = {
  'all':
    '''
    SELECT ${Outfit.tblLink}.${Outfit.colOutfitId},
           GROUP_CONCAT(${Item.tblItem}.${Item.colItemId}   , ',')
             AS ${Outfit.colItemIds},
           GROUP_CONCAT(${Item.tblItem}.${Item.colImageName}, ',')
             AS ${Outfit.colImageNames}
    FROM ${Outfit.tblLink}
      INNER JOIN ${Item.tblItem}
        ON ${Outfit.tblLink}.${Item.colItemId}
         = ${Item.tblItem}.${Item.colItemId}
    GROUP BY ${Outfit.tblLink}.${Outfit.colOutfitId};
    ''',
  'possible':
    '''
    SELECT ${Outfit.colOutfitId},
           ${Outfit.colItemIds},
           ${Outfit.colImageNames}
    FROM(
      SELECT ${Outfit.tblLink}.${Outfit.colOutfitId},
             GROUP_CONCAT(${Item.tblItem}.${Item.colItemId}, ',')
               AS ${Outfit.colItemIds},
             GROUP_CONCAT(${Item.tblItem}.${Item.colImageName}, ',')
               AS ${Outfit.colImageNames},
             MIN(${Item.tblItem}.${Item.colOwned})
               AS ${Outfit.colPossible}
      FROM ${Outfit.tblLink}
        INNER JOIN ${Item.tblItem}
          ON ${Outfit.tblLink}.${Item.colItemId}
           = ${Item.tblItem}.${Item.colItemId}
      GROUP BY ${Outfit.tblLink}.${Outfit.colOutfitId}
    )
    WHERE ${Outfit.colPossible} == 1;
    ''',
};
