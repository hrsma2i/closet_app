import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:closet_app/AppDatabase.dart';
import 'package:closet_app/item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int index = 0;
  final List<Item> itemList = new List();
  String homeTitle = "today";
  bool init = true;

  @override
  void initState() {
    updateItems();
    super.initState();
  }

  void updateItems() {
    AppDatabase
      .get()
      .getOwnedItems()
      .then(
        (items) {
          if (items == null) return;
          setState(
            () {
              itemList.clear();
              itemList.addAll(items);
            }
          );
        }
      );
  }

  List<Widget> getItemImages () {
    return itemList.map(
      (item) => Image(image: AssetImage(item.imageName)),
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
              child: PageWithTabs(
                'outfits',
                [
                  TabItem("today's",  getItemImages()),
                  TabItem("possible", getItemImages()),
                  TabItem("all",      getItemImages()),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: PageWithTabs(
                'Items',
                [
                  TabItem("owned",  getItemImages()),
                  TabItem("to buy", getItemImages()),
                  TabItem("all",    getItemImages()),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: index != 2,
              child: new TickerMode(
              enabled: index == 2,
              child: PageWithTabs(
                'Find',
                [
                  TabItem("outfit",   getItemImages()),
                  TabItem("new item", getItemImages()),
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

class TabItem extends StatelessWidget {
  String tabName;
  List<Widget> grids;

  TabItem(this.tabName, this.grids);

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

class PageWithTabs extends StatelessWidget {
  String pageName;
  List<TabItem> tabItems;

  PageWithTabs(this.pageName, this.tabItems);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItems.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pageName),
          bottom: TabBar(
            tabs: tabItems.map(
                    (tabItem) => new Tab(text: tabItem.tabName)
            ).toList(),
          ),
        ),
        body: TabBarView(
          children: tabItems,
        ),
      ),
    );
  }
}

