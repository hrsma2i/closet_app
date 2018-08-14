import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:quiver/iterables.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/item.dart';
import 'package:closet_app/outfit.dart';
import 'package:closet_app/item_details_page.dart';
import 'package:closet_app/utils.dart';
import 'package:closet_app/sql.dart';
import 'package:closet_app/typedef.dart';
import 'package:closet_app/filter_page.dart';


class HomeScreen extends StatelessWidget {
  static List<ItemTopTab> itemTopTabs = [
    ItemTopTab('owned'),
    ItemTopTab('to buy'),
    ItemTopTab('all'),
  ];

  static List<OutfitTopTab> outfitTopTabs = [
    OutfitTopTab('today'),
    OutfitTopTab('possible'),
    OutfitTopTab('all'),
  ];

  static List<Widget> bottomPages = [
    BottomPageWithTopTabs('Outfit', outfitTopTabs),
    BottomPageWithTopTabs('Items',  itemTopTabs),
    BottomPageWithTopTabs('Find',   [
      FindOutfitTopTab('outfit'),
    ]),
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
                    (topTab) => new Tab(text: topTab.title)
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
  String title;

  State createState();
}

class ItemTopTab extends TopTab {
  String title;

  ItemTopTab(this.title);

  @override
  ItemTopTabState createState() => new ItemTopTabState(title);
}


class ItemTopTabState extends State<ItemTopTab> {
  final String title;
  final List<Item> _items = new List();
  String queryName;

  ItemTopTabState(this.title);

  @override
  void initState(){
    queryName = title;
    updateItems();
    super.initState();
  }

  void updateItems() {
    ClosetDatabase.get()
        .getItems(sqlMapItem[queryName])
        .then((items) {
          setState(() {
            _items.clear();
            _items.addAll(items);
          });
        });
  }

  void updateItemsByQuery(sql) {
    ClosetDatabase.get()
        .getItems(sql)
        .then((items) {
      setState(() {
        _items.clear();
        _items.addAll(items);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FancyFab(
        heroTag: "item_${this.title}",
        updateItemsByQuery: updateItemsByQuery,
      ),
      body:_items != null
        ? new Padding(
          padding: EdgeInsets.all(2.5),
          child: GridView.builder(
            padding: const EdgeInsets.all(2.5),
            itemBuilder: (BuildContext context, int index) =>
              new ItemCard(_items[index], updateItems),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.5,
            ),
            itemCount: _items.length,
          )
        )
        : new Container()
    );
  }
}

class ItemCard extends StatelessWidget {
  Item item;
  ItemUpdater updateItem;

  ItemCard(this.item, this.updateItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          new FadeRoute(
            builder: (BuildContext context) =>
                new ItemDetailsPage(item, updateItem),
            settings: new RouteSettings(
              name: '/item_detail',
              isInitialRoute: false
            ),
          )
        );
      },
      child: new Card(
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Image.asset(
            join('images', item.imageName)
          ),
        )
      ),
    );
  }
}

class OutfitTopTab extends TopTab {
  String title;

  OutfitTopTab(this.title);

  @override
  OutfitTopTabState createState() => new OutfitTopTabState(title);
}


class OutfitTopTabState extends State<OutfitTopTab> {
  String name;
  final List<Outfit> _outfits = new List();

  OutfitTopTabState(this.name);

  @override
  void initState(){
    super.initState();
    ClosetDatabase.get()
        .getOutfits(sqlMapOutfit[name])
        .then((outfits) {
      setState(() {
        _outfits.clear();
        _outfits.addAll(outfits);
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _outfits != null
      ? GridView.builder(
        padding: const EdgeInsets.all(5.0),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5.0,
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, index) =>
          OutfitCard(_outfits[index].imageNames),
        itemCount: _outfits.length,
      )
      : new Container();
  }
}

class OutfitCard extends StatelessWidget {
  List<String> imageNames;

  OutfitCard(this.imageNames);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new GridView.count(
        primary: false,
        padding: const EdgeInsets.all(0.0),
        crossAxisSpacing: 0.0,
        crossAxisCount: sqrt(imageNames.length).ceil(),
        children: imageNames.map(
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

class FancyFab extends StatefulWidget {
  final Object heroTag;
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  final ItemsUpdaterByQuery updateItemsByQuery;

  FancyFab({
    this.heroTag,
    this.onPressed,
    this.tooltip,
    this.icon,

    this.updateItemsByQuery,
  });

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  void initState() {
    _animationController = 
      AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      )..addListener((){
        setState((){});
      });

    _animateIcon =
      Tween<double>(
        begin: 0.0,
        end: 1.0
      ).animate(_animationController);

    _animateColor = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          1.00,
          curve: _curve,
        ),
      )
    );

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      )
    ));
    super.initState();
  }

  @override
  dispose(){
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget sort(){
    return new Container(
      child: FloatingActionButton(
        heroTag: "${widget.heroTag}_sort",
        onPressed: null,
        tooltip: 'Sort',
        child: Icon(Icons.sort),
      ),
    );
  }

  Widget filter(BuildContext context){
    return new Container(
      child: FloatingActionButton(
        heroTag: "${widget.heroTag}_filter",
        onPressed: (){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) =>
              new FilterPage(),
              settings: new RouteSettings(
                  name: '/edit_filter',
                  isInitialRoute: false
              ),
            )
          ).then((sql){
            widget.updateItemsByQuery(sql);
          });
        },
        tooltip: 'Filter',
        child: Icon(Icons.filter_list),
      ),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: "${widget.heroTag}_toggle",
      backgroundColor: _animateColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: sort(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1.0,
            0.0,
          ),
          child: filter(context),
        ),
        toggle(),
      ],
    );
  }
}

class FindOutfitTopTab extends TopTab {
  String title;

  FindOutfitTopTab(this.title);

  @override
  FindOutfitTopTabState createState() => new FindOutfitTopTabState(title);
}


class FindOutfitTopTabState extends State<FindOutfitTopTab> {
  String name;
  List<Widget> gridCells;

  FindOutfitTopTabState(this.name);

  static List<List<String>> howCmbs = [
    ['tops', 'bottoms', 'shoes'],
    ['tops', 'under', 'bottoms', 'shoes'],
    ['outer', 'tops', 'bottoms', 'shoes'],
    ['outer', 'tops', 'under', 'bottoms', 'shoes'],
  ];

  List<String> howCmb = howCmbs[0];

  getCandidates() async {
    Map<String, List<Item>> candidates = {};

    await Future.forEach(howCmb, (how) async {
      String sql = """
        SELECT *
        FROM ${Item.tblItem}
          INNER JOIN ${Item.tblCategoryHow}
            ON ${Item.tblItem}.${Item.colTypeCategory}
             = ${Item.tblCategoryHow}.${Item.colTypeCategory}
        WHERE ${Item.tblCategoryHow}.${Item.colHow} == '$how';
      """;
      //ClosetDatabase
      //  .get().getItems(sql)
      //  .then((items) {
      //    print(items);
      //    candidates[how] = items;
      //  });
      candidates[how] = await ClosetDatabase
        .get().getItems(sql);
    });

    return candidates;
  }

  @override
  void initState() {
    super.initState();
    int nSample = 20;
    getCandidates().then((candidates) {
      setState(() {
        Random random = Random();
        gridCells = List.generate(nSample, (int i) =>
          OutfitCard(
            howCmb.map<String>((how) {
              return candidates[how]
              [random.nextInt(candidates[how].length)].imageName;
            }).toList()
          )
        );
      });
    });
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
