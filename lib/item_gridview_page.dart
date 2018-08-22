import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:quiver/iterables.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/sql.dart';
import 'package:closet_app/item.dart';
import 'package:closet_app/items_model.dart';
import 'package:closet_app/item_details_page.dart';
import 'package:closet_app/item_filter_page.dart';
import 'package:closet_app/typedef.dart';


class ItemGrid extends StatefulWidget {
  String queryName;

  ItemGrid({this.queryName});

  @override
  ItemGridState createState() => new ItemGridState();
}


class ItemGridState extends State<ItemGrid> {
  //final ItemsModel model;
  //List<Item> _items;

  @override
  void initState(){
    //updateItemsByQuery(sqlMapItem[widget.queryName]);
    //_items = model.items;
    super.initState();
  }

  /*
  void updateItemsByQuery(String sql) {
    print('updateItemsByQuery');
    ClosetDatabase.get()
      .getItems(sql)
      .then((items) {
        setState(() {
          _items = items;
        });
      }
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ItemsModel>(
      builder: (context, child, model) {
        return Scaffold(
          floatingActionButton: new FancyFab(
            heroTag: "item_${widget.queryName}",
            //updateItemsByQuery: updateItemsByQuery,
          ),
          body: model.items != null
            ? () {
              print('build ItemGrid');
              if (model.items.length == 0) {
                model.updateItemsByQuery(sqlMapItem[widget.queryName]);
              }
              return new Padding(
                  padding: EdgeInsets.all(2.5),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(2.5),
                    itemBuilder: (BuildContext context, int index) =>
                    new ItemCard(model.items[index]),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.5,
                    ),
                    itemCount: model.items.length,
                  )
              );
            }()
            : Container()
        );
      }
    );
  }
}

class ItemCard extends StatelessWidget {
  Item item;

  ItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) =>
                ItemDetailsPage(item.itemId)
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


class FancyFab extends StatefulWidget {
  final Object heroTag;
  final Function onPressed;
  final String tooltip;
  final IconData icon;

  //final ItemsUpdaterByQuery updateItemsByQuery;

  FancyFab({
    this.heroTag,
    this.onPressed,
    this.tooltip,
    this.icon,

    //this.updateItemsByQuery,
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
            //widget.updateItemsByQuery(sql);
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

