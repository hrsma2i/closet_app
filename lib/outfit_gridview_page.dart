import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/database.dart';
import 'package:closet_app/sql.dart';
import 'package:closet_app/outfit.dart';
import 'package:closet_app/outfits_model.dart';
//import 'package:closet_app/outfit_details_page.dart';
import 'package:closet_app/outfit_filter_page.dart';


class OutfitGrid extends StatefulWidget {
  String queryName;

  OutfitGrid({this.queryName});

  @override
  OutfitGridState createState() =>  OutfitGridState();
}


class OutfitGridState extends State<OutfitGrid> {
  final OutfitsModel model = OutfitsModel();

  @override
  void initState(){
    updateOutfitsByQuery(sqlMapOutfit[widget.queryName]);
    super.initState();
  }

  void updateOutfitsByQuery(String sql) {
    ClosetDatabase.get()
      .getOutfits(sql)
      .then((outfits) {
        setState(() {
          model.updateOutfits(outfits);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OutfitsModel>(
      model: model,
      child: Scaffold(
        floatingActionButton: FancyFabOutfit(
          heroTag: "outfit_${widget.queryName}_"
            "${model.outfits}",
          updateCallback: updateOutfitsByQuery,
          query: sqlMapOutfit[widget.queryName],
        ),
        body: model.outfits != null
          ? Padding(
              padding: EdgeInsets.all(2.5),
              child: GridView.builder(
                padding: const EdgeInsets.all(2.5),
                itemBuilder: (BuildContext context, int index) =>
                 OutfitCard(model.outfits[index]),
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.5,
                ),
                itemCount: model.outfits.length,
              )
            )
          : Container()
      )
    );
  }
}

class OutfitCard extends StatelessWidget {
  Outfit outfit;

  OutfitCard(this.outfit);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OutfitsModel>(
      builder: (context, child, model){
        return GestureDetector(
          onTap: () {
            //Navigator.of(context).push(
            //  MaterialPageRoute(
            //    builder: (context) =>
            //      OutfitDetailsPage(outfit)
            //  )
            //).then((outfit) {
            //  model.updateOutfit(outfit);
            //});
          },
          child: Card(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(1.0),
              children: outfit.imageNames.map((imageName) =>
                Image.asset(
                  join('images', imageName)
                )
              ).toList(),
              crossAxisSpacing: 0.0,
              crossAxisCount: sqrt(outfit.imageNames.length).ceil(),
            )
          ),
        );
      }
    );
  }
}


class FancyFabOutfit extends StatefulWidget {
  final Object heroTag;
  final Function onPressed;
  final String tooltip;
  final IconData icon;

  final Function updateCallback;
  final String query;

  FancyFabOutfit({
    this.heroTag,
    this.onPressed,
    this.tooltip,
    this.icon,

    this.updateCallback,
    this.query,
  });

  @override
  _FancyFabOutfitState createState() => _FancyFabOutfitState();
}

class _FancyFabOutfitState extends State<FancyFabOutfit>
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
    return  Container(
      child: FloatingActionButton(
        heroTag: "${widget.heroTag}_sort_outfit",
        onPressed: null,
        tooltip: 'Sort',
        child: Icon(Icons.sort),
      ),
    );
  }

  Widget filter(BuildContext context){
    return  Container(
      child: FloatingActionButton(
        heroTag: "${widget.heroTag}_filter_outfit",
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                OutfitFilterPage(originalQuery: widget.query),
              settings:  RouteSettings(
                name: '/edit_filter',
                isInitialRoute: false
              ),
            )
          ).then((sql){
            widget.updateCallback(sql);
          });
        },
        tooltip: 'Filter',
        child: Icon(Icons.filter_list),
      ),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: "${widget.heroTag}_toggle_outfit",
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

