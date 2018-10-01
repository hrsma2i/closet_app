import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/sql.dart';
import 'package:closet_app/item.dart';
import 'package:closet_app/items_model.dart';
import 'package:closet_app/item_details_page.dart';
import 'package:closet_app/item_filter_page.dart';


class ItemGrid extends StatefulWidget {
  String queryName;
  bool selectable;

  ItemGrid({this.queryName, this.selectable=false});

  @override
  ItemGridState createState() =>  ItemGridState();
}


class ItemGridState extends State<ItemGrid> {
  final ItemsModel model = ItemsModel();
  List<Item> _items;
  List<Item> _selectedItems;

  @override
  void initState(){
    _selectedItems = [];
    updateItemsByQuery(sqlMapItem[widget.queryName]);
    super.initState();
  }

  void updateItem(Item item) {
    ClosetDatabase.get()
        .updateItem(item);
    updateItemsByQuery(sqlMapItem[widget.queryName]);
  }

  void updateItemsByQuery(String sql) {
    ClosetDatabase.get()
      .getItems(sql)
      .then((items) {
        setState(() {
          //model.updateItems(items);
          _items = items;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FancyFab(
        heroTag: "item_${widget.queryName}_"
          "$_items",
        callbackUpdate: updateItemsByQuery,
        selectable: widget.selectable,
        items: _selectedItems,
      ),
      body: _items != null
        ? Padding(
            padding: EdgeInsets.all(2.5),
            child: GridView.builder(
              padding: const EdgeInsets.all(2.5),
              itemBuilder: (BuildContext context, int index) =>
               ItemCard(
                 item: _items[index],
                 context: context,
               ),
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.5,
              ),
              itemCount: _items.length,
            )
          )
        : Container()
    );
  }

  Widget ItemCard({Item item, BuildContext context}) {
    bool selected = _selectedItems.contains(item);
    Widget image = Image.asset(join('images', item.imageName));

    return GestureDetector(
      onTap: () {
        if (!widget.selectable) {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ItemDetailsPage(item)
              )
          ).then((item) {
            updateItem(item);
          });
        } else {
          if (selected) {
            setState(() {
              _selectedItems.remove(item);
            });
          } else {
            setState(() {
              _selectedItems.add(item);
            });
          }
          selected = !selected;
        }
      },
      child: Card(
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: widget.selectable
              ? Stack(
                children: <Widget>[
                  image,
                  selectedMark(selected),
                ],
              )
              : image
          )
      ),
    );
  }

  Widget selectedMark(selected) {
    return Container(
      height: 30.0,
      width: 30.0,
      alignment: Alignment.center,
      child: selected
        ? Icon(Icons.check_circle)
        : Icon(Icons.check_circle_outline),
    );
  }

}


class FancyFab extends StatefulWidget {
  final Object heroTag;
  final Function onPressed;
  final String tooltip;
  final IconData icon;
  final Function callbackUpdate;
  bool selectable;
  List<Item> items;

  FancyFab({
    this.heroTag,
    this.onPressed,
    this.tooltip,
    this.icon,
    this.callbackUpdate,
    this.selectable,
    this.items,
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
  Widget build(BuildContext context) {
    List<Widget> buttons = [
      sort(),
      filter(context),
    ];

    if (widget.selectable) {
      buttons.insert(0, check(context));
    }

    buttons = List.generate(buttons.length, (i) =>
      Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translateButton.value * (buttons.length-i),
          0.0,
        ),
        child: buttons[i],
      )
    );

    buttons.add(toggle());

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buttons,
    );
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
    return  Container(
      child: FloatingActionButton(
        heroTag: "${widget.heroTag}_sort",
        onPressed: null,
        tooltip: 'Sort',
        child: Icon(Icons.sort),
      ),
    );
  }

  Widget filter(BuildContext context){
    return  Container(
      child: FloatingActionButton(
        heroTag: "${widget.heroTag}_filter",
        onPressed: (){
          Navigator.of(context).push(
             MaterialPageRoute(
              builder: (context) =>
               FilterPage(),
              settings:  RouteSettings(
                  name: '/edit_filter',
                  isInitialRoute: false
              ),
            )
          ).then((sql){
            widget.callbackUpdate(sql);
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

  Widget check(context) {
    return FloatingActionButton(
      heroTag: "${widget.heroTag}_check",
      onPressed: (){
        Navigator.pop(context, widget.items);
        for (Item item in widget.items) {
          print(item.name);
        }
      },
      tooltip: 'Check',
      child: Icon(Icons.check),
    );
  }
}

