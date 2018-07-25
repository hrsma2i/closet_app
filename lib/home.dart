import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:quiver/iterables.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeScreen> {
  List<Item> _items = new List();

  int index = 0;
  String homeTitle = "today";

  @override
  void initState() {
    ClosetDatabase.get().init();
    updateItems('owned');
    super.initState();
  }

  void updateItems(sqlKey) {
    ClosetDatabase.get().getItems(sqlMap[sqlKey])
      .then((items){
        setState(() {
          _items.clear();
          _items.addAll(items);
        });
      });
  }

  List<Widget> getItemImages () {
    return _items.map(
      (item) => Image(
        image: AssetImage(
          join('images', item.imageName)
        )
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          Offstage(
            offstage: index != 0,
            child: new TickerMode(
              enabled: index == 0,
              child: BottomPageWithTopTabs(
                'outfits',
                [
                  TopTab("today's",  getItemImages()),
                  TopTab("possible", getItemImages()),
                  TopTab("all",      getItemImages()),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: BottomPageWithTopTabs(
                'Items',
                [
                  TopTab("owned",  getItemImages()),
                  TopTab("to buy", getItemImages()),
                  TopTab("all",    getItemImages()),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: index != 2,
              child: new TickerMode(
              enabled: index == 2,
              child: BottomPageWithTopTabs(
                'Find',
                [
                  TopTab("outfit",   getItemImages()),
                  TopTab("new item", getItemImages()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){},
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) { setState((){ this.index = index; }); },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new ImageIcon(
              AssetImage('./icons/outfit_fill.png'),
            ),
            title: new Text("outfits"),
          ),
          new BottomNavigationBarItem(
            icon: new ImageIcon(
              AssetImage('./icons/T_fill.png'),
            ),
            title: new Text("items"),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: new Text("find"),
          ),
        ],
      ),
    );
  }
}

class BottomPageContainer extends StatefulWidget {
  List<BottomPageWithTopTabs> bottomPages;
  BottomPageContainer(this.bottomPages);
  @override
  BottomPageContainerState createState() => new BottomPageContainerState(bottomPages);
}

class BottomPageContainerState extends State<BottomPageContainer> {
  int index = 0;
  List<BottomPageWithTopTabs> bottomPages;
  List<String> names;
  List<Icon> icons;

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
  List<TopTab> TopTabs;

  BottomPageWithTopTabs(this.name, this.TopTabs);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TopTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          bottom: TabBar(
            tabs: TopTabs.map(
                    (topTab) => new Tab(text: topTab.name)
            ).toList(),
          ),
        ),
        body: TabBarView(
          children: TopTabs,
        ),
      ),
    );
  }
}

class TopTab extends StatelessWidget {
  String name;
  List<Widget> grids;

  TopTab(this.name, this.grids);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 3,
      children: grids,
    );
  }
}

Map<String, String> sqlMap = {
  'owned':
    '''
    SELECT * FROM ${Item.tableItem}
    WHERE ${Item.columnOwned} == 1;
    ''',
  'all':
    '''
    SELECT * FROM ${Item.tableItem};
    ''',
};