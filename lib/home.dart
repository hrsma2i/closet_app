import 'package:flutter/material.dart';

import 'package:closet_app/item_gridview_page.dart';
import 'package:closet_app/outfit_gridview_page.dart';


class HomeScreen extends StatefulWidget {
  final List<String> itemTabTitles = [
    'owned',
    'to buy',
    'all',
  ];

  final List<String> outfitTabTitles = [
    'today',
    'possible',
    'all',
  ];

  //static List<OutfitTopTab> outfitTopTabs = [
  //  OutfitTopTab('today'),
  //  OutfitTopTab('possible'),
  //  OutfitTopTab('all'),
  //];


  //static List<String> names = [
  //  'Outfit',
  //  'Items',
  //  'Find',
  //];

  static List<Widget> icons = [
    ImageIcon(
      AssetImage('./icons/outfit_fill.png'),
    ),
    ImageIcon(
      AssetImage('./icons/T_fill.png'),
    ),
    Icon(Icons.search),
  ];

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int index = 0;
  //List<String> itemTabTitles;

  @override
  void initState() {
    //itemTabTitles = [
    //  'owned',
    //  'to buy',
    //  'all',
    //];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BottomPageWithTopTabs> bottomPages = [
      BottomPageWithTopTabs(
        title: 'Outfits',
        icon: ImageIcon(
          AssetImage('./icons/outfit_fill.png'),
        ),
        tabTitles: widget.outfitTabTitles,
        children: widget.outfitTabTitles.map((tabTitle) =>
            OutfitGrid(queryName: tabTitle)
        ).toList(),
      ),
      BottomPageWithTopTabs(
        title: 'Items',
        icon: ImageIcon(
          AssetImage('./icons/T_fill.png'),
        ),
        tabTitles: widget.itemTabTitles,
        children: widget.itemTabTitles.map((tabTitle) =>
            ItemGrid(queryName: tabTitle)
        ).toList(),
      ),
    ];
    return Scaffold(
      body: Stack(
        children: List<Offstage>.generate(
          bottomPages.length,
          (int i) => Offstage(
            offstage: index != i,
            child: TickerMode(
              enabled: index == i,
              child: bottomPages[i]
            )
          )
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) { setState((){ this.index = index; }); },
        items: bottomPages.map((btmPg) =>
          BottomNavigationBarItem(
            icon: btmPg.icon,
            title: Text(btmPg.title),
          )
        ).toList(),
      ),
    );
  }
}


class BottomPageWithTopTabs extends StatelessWidget {
  String title;
  Widget icon;
  List<String> tabTitles;
  List<Widget> children;

  BottomPageWithTopTabs({
    this.title,
    this.icon,
    this.tabTitles,
    this.children
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: tabTitles.map(
              (tabTitle) => Tab(text: tabTitle)
            ).toList(),
          ),
        ),
        body: TabBarView(
          children: children,
        ),
      ),
    );
  }
}

//abstract class TopTab extends StatefulWidget {
//  String title;
//
//  State createState();
//}

//class ItemTopTab extends TopTab {
//  String title;
//
//  ItemTopTab(this.title);
//
//  @override
//  ItemTopTabState createState() => ItemTopTabState(title);
//}


//class ItemTopTabState extends State<ItemTopTab> {
//  final String title;
//  final List<Item> _items = List();
//  String queryName;
//
//  ItemTopTabState(this.title);
//
//  @override
//  void initState(){
//    queryName = title;
//    updateItems();
//    super.initState();
//  }
//
//  void updateItems() {
//    ClosetDatabase.get()
//        .getItems(sqlMapItem[queryName])
//        .then((items) {
//          setState(() {
//            _items.clear();
//            _items.addAll(items);
//          });
//        });
//  }
//
//  void updateItemsByQuery(sql) {
//    ClosetDatabase.get()
//        .getItems(sql)
//        .then((items) {
//      setState(() {
//        _items.clear();
//        _items.addAll(items);
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      floatingActionButton: FancyFab(
//        heroTag: "item_${this.title}",
//        updateItemsByQuery: updateItemsByQuery,
//      ),
//      body:_items != null
//        ? Padding(
//          padding: EdgeInsets.all(2.5),
//          child: GridView.builder(
//            padding: const EdgeInsets.all(2.5),
//            itemBuilder: (BuildContext context, int index) =>
//              ItemCard(_items[index], updateItems),
//            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//              crossAxisCount: 3,
//              crossAxisSpacing: 2.5,
//            ),
//            itemCount: _items.length,
//          )
//        )
//        : Container()
//    );
//  }
//}

//class ItemCard extends StatelessWidget {
//  Item item;
//  ItemUpdater updateItem;
//
//  ItemCard(this.item, this.updateItem);
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: (){
//        Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (BuildContext context) =>
//                ItemDetailsPage(item),
//          )
//        );
//      },
//      child: Card(
//        child: Padding(
//          padding: EdgeInsets.all(3.0),
//          child: Image.asset(
//            join('images', item.imageName)
//          ),
//        )
//      ),
//    );
//  }
//}

//class OutfitTopTab extends TopTab {
//  String title;
//
//  OutfitTopTab(this.title);
//
//  @override
//  OutfitTopTabState createState() => OutfitTopTabState(title);
//}
//
//
//class OutfitTopTabState extends State<OutfitTopTab> {
//  String name;
//  final List<Outfit> _outfits = List();
//
//  OutfitTopTabState(this.name);
//
//  @override
//  void initState(){
//    super.initState();
//    ClosetDatabase.get()
//        .getOutfits(sqlMapOutfit[name])
//        .then((outfits) {
//      setState(() {
//        _outfits.clear();
//        _outfits.addAll(outfits);
//      });
//    }
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return _outfits != null
//      ? GridView.builder(
//        padding: const EdgeInsets.all(5.0),
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisSpacing: 5.0,
//          crossAxisCount: 2,
//        ),
//        itemBuilder: (BuildContext context, index) =>
//          OutfitCard(_outfits[index].imageNames),
//        itemCount: _outfits.length,
//      )
//      : Container();
//  }
//}
//
//class OutfitCard extends StatelessWidget {
//  List<String> imageNames;
//
//  OutfitCard(this.imageNames);
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      child: GridView.count(
//        primary: false,
//        padding: const EdgeInsets.all(0.0),
//        crossAxisSpacing: 0.0,
//        crossAxisCount: sqrt(imageNames.length).ceil(),
//        children: imageNames.map(
//                (imageName) => Padding(
//              padding: EdgeInsets.all(3.0),
//              child: Image(
//                  image: AssetImage(
//                      join('images', imageName)
//                  )
//              ),
//            )
//        ).toList(),
//      ),
//    );
//  }
//}
//
//class FancyFab extends StatefulWidget {
//  final Object heroTag;
//  final Function() onPressed;
//  final String tooltip;
//  final IconData icon;
//
//  final ItemsUpdaterByQuery updateItemsByQuery;
//
//  FancyFab({
//    this.heroTag,
//    this.onPressed,
//    this.tooltip,
//    this.icon,
//
//    this.updateItemsByQuery,
//  });
//
//  @override
//  _FancyFabState createState() => _FancyFabState();
//}
//
//class _FancyFabState extends State<FancyFab>
//    with SingleTickerProviderStateMixin {
//  bool isOpened = false;
//  AnimationController _animationController;
//  Animation<Color> _animateColor;
//  Animation<double> _animateIcon;
//  Animation<double> _translateButton;
//  Curve _curve = Curves.easeOut;
//  double _fabHeight = 56.0;
//
//  @override
//  void initState() {
//    _animationController =
//      AnimationController(
//        vsync: this,
//        duration: Duration(milliseconds: 200),
//      )..addListener((){
//        setState((){});
//      });
//
//    _animateIcon =
//      Tween<double>(
//        begin: 0.0,
//        end: 1.0
//      ).animate(_animationController);
//
//    _animateColor = ColorTween(
//      begin: Colors.blueGrey,
//      end: Colors.red,
//    ).animate(
//      CurvedAnimation(
//        parent: _animationController,
//        curve: Interval(
//          0.00,
//          1.00,
//          curve: _curve,
//        ),
//      )
//    );
//
//    _translateButton = Tween<double>(
//      begin: _fabHeight,
//      end: -14.0,
//    ).animate(CurvedAnimation(
//      parent: _animationController,
//      curve: Interval(
//        0.0,
//        0.75,
//        curve: _curve,
//      )
//    ));
//    super.initState();
//  }
//
//  @override
//  dispose(){
//    _animationController.dispose();
//    super.dispose();
//  }
//
//  animate() {
//    if (!isOpened) {
//      _animationController.forward();
//    } else {
//      _animationController.reverse();
//    }
//    isOpened = !isOpened;
//  }
//
//  Widget sort(){
//    return Container(
//      child: FloatingActionButton(
//        heroTag: "${widget.heroTag}_sort",
//        onPressed: null,
//        tooltip: 'Sort',
//        child: Icon(Icons.sort),
//      ),
//    );
//  }
//
//  Widget filter(BuildContext context){
//    return Container(
//      child: FloatingActionButton(
//        heroTag: "${widget.heroTag}_filter",
//        onPressed: (){
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) =>
//              FilterPage(),
//              settings: RouteSettings(
//                  name: '/edit_filter',
//                  isInitialRoute: false
//              ),
//            )
//          ).then((sql){
//            widget.updateItemsByQuery(sql);
//          });
//        },
//        tooltip: 'Filter',
//        child: Icon(Icons.filter_list),
//      ),
//    );
//  }
//
//  Widget toggle() {
//    return FloatingActionButton(
//      heroTag: "${widget.heroTag}_toggle",
//      backgroundColor: _animateColor.value,
//      onPressed: animate,
//      tooltip: 'Toggle',
//      child: AnimatedIcon(
//        icon: AnimatedIcons.menu_close,
//        progress: _animateIcon,
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.end,
//      children: <Widget>[
//        Transform(
//          transform: Matrix4.translationValues(
//            0.0,
//            _translateButton.value * 2.0,
//            0.0,
//          ),
//          child: sort(),
//        ),
//        Transform(
//          transform: Matrix4.translationValues(
//            0.0,
//            _translateButton.value * 1.0,
//            0.0,
//          ),
//          child: filter(context),
//        ),
//        toggle(),
//      ],
//    );
//  }
//}
//
//class FindOutfitTopTab extends TopTab {
//  String title;
//
//  FindOutfitTopTab(this.title);
//
//  @override
//  FindOutfitTopTabState createState() => FindOutfitTopTabState(title);
//}
//
//
//class FindOutfitTopTabState extends State<FindOutfitTopTab> {
//  String name;
//  List<Widget> gridCells;
//
//  FindOutfitTopTabState(this.name);
//
//  static List<List<String>> howCmbs = [
//    ['tops', 'bottoms', 'shoes'],
//    ['tops', 'under', 'bottoms', 'shoes'],
//    ['outer', 'tops', 'bottoms', 'shoes'],
//    ['outer', 'tops', 'under', 'bottoms', 'shoes'],
//  ];
//
//  List<String> howCmb = howCmbs[0];
//
//  getCandidates() async {
//    Map<String, List<Item>> candidates = {};
//
//    await Future.forEach(howCmb, (how) async {
//      String sql = """
//        SELECT *
//        FROM ${Item.tblItem}
//          INNER JOIN ${Item.tblCategoryHow}
//            ON ${Item.tblItem}.${Item.colTypeCategory}
//             = ${Item.tblCategoryHow}.${Item.colTypeCategory}
//        WHERE ${Item.tblCategoryHow}.${Item.colHow} == '$how';
//      """;
//      //ClosetDatabase
//      //  .get().getItems(sql)
//      //  .then((items) {
//      //    print(items);
//      //    candidates[how] = items;
//      //  });
//      candidates[how] = await ClosetDatabase
//        .get().getItems(sql);
//    });
//
//    return candidates;
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    int nSample = 20;
//    getCandidates().then((candidates) {
//      setState(() {
//        Random random = Random();
//        gridCells = List.generate(nSample, (int i) =>
//          OutfitCard(
//            howCmb.map<String>((how) {
//              return candidates[how]
//              [random.nextInt(candidates[how].length)].imageName;
//            }).toList()
//          )
//        );
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return gridCells != null
//      ? GridView.count(
//        primary: false,
//        padding: const EdgeInsets.all(5.0),
//        crossAxisSpacing: 5.0,
//        crossAxisCount: 2,
//        children: gridCells,
//      )
//      : Container();
//  }
//}
