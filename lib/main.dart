import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'data.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(new MyApp());

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Closet App',
//      debugShowCheckedModeBanner: false,
//      theme: new ThemeData.dark(),
//      home: Home(),
//      onGenerateRoute: (settings) => generateRoute(settings),
//    );
//  }
//
//  generateRoute(RouteSettings settings) {
//    final path = settings.name.split('/');
//    final category = path[1];
//
//    Item item = items.firstWhere((it) => it.category == category);
//    return MaterialPageRoute(
//      settings: settings,
//      builder: (context) => Detail(item),
//    );
//  }
//}

class MyApp extends StatefulWidget {
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {

  int index = 0;

  Future getImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      itemImages.add(Image.file(imageFile));
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        body: new Stack(
          children: [
            Offstage(
              offstage: index != 0,
              child: new TickerMode(
                  enabled: index == 0,
                  child: PageWithTabs(
                    'Outfits',
                    [
                      TabItem("today's",  outfitImages),
                      TabItem("possible", outfitImages),
                      TabItem("all",      outfitImages),
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
                    TabItem("all", itemImages),
                    TabItem("owned", itemImages),
                    TabItem("to buy", itemImages),
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
                    TabItem("outfit", outfitImages),
                    TabItem("new item", itemImages),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
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
          title: Text("Outfits"),
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

