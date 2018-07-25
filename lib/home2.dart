import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:quiver/iterables.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/item.dart';

class HomeScreen extends StatelessWidget {
  static List<TopTab> itemTopTabs = [
    TopTab('owned'),
    TopTab('to buy'),
    TopTab('all'),
  ];

  static List<Widget> bottomPages = [
    BottomPageWithTopTabs('Outfit', itemTopTabs),
    BottomPageWithTopTabs('Items', itemTopTabs),
    BottomPageWithTopTabs('Find', itemTopTabs),
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

class TopTab extends StatefulWidget {
  String name;

  TopTab(this.name);

  @override
  TopTabState createState() => new TopTabState(name);
}


class TopTabState extends State<TopTab> {
  String name;
  List<Widget> gridCells;

  TopTabState(this.name);

  @override
  void initState(){
    super.initState();
    ClosetDatabase.get()
      .getItems(sqlMap[name])
      .then((items) {
          setState(() {
            gridCells = items.map(
                (item) => Image(
                image: AssetImage(
                    join('images', item.imageName)
                )
              ),
            ).toList();
          });
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 3,
      children: gridCells,
    );
  }
}

Map<String, String> sqlMap = {
  'owned':
    '''
    SELECT * FROM ${Item.tableItem}
    WHERE ${Item.columnOwned} == 1;
    ''',
  'to buy':
    '''
    SELECT * FROM ${Item.tableItem}
    WHERE ${Item.columnOwned} == 0;
    ''',
  'all':
    '''
    SELECT * FROM ${Item.tableItem};
    ''',
};