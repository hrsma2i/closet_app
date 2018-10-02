import 'package:flutter/material.dart';
import 'package:closet_app/color.dart';

class SelectColorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select category"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            colorColumn(["black", "grey", "white", "all"]),
            colorColumn(["brown", "camel", "beige"]),
            colorColumn(["orange", "yellow"]),
            colorColumn(["wine", "red", "pink"]),
            colorColumn(["purple", "violet"]),
            colorColumn(["navy", "blue", "sky_blue"]),
            colorColumn(["olive", "green"]),
          ],
        ),
      ),
    );
  }
}

class colorColumn extends StatelessWidget {
  List<String> colorNames;

  colorColumn(this.colorNames);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: colorNames.map((name) =>
          ColorCard(
            colorName: name,
            onTap: () {
              Navigator.of(context).pop(name);
            },
          )
        ).toList(),
      ),
    );
  }
}

class ColorCard extends StatelessWidget {
  String colorName;
  Function onTap;

  ColorCard({this.colorName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        child: colorName == "all"
          ? allColor()
          : Card(
            color: name2color[colorName],
          ),
        onTap: onTap,
      ),
    );
  }

  Widget allColor() {
    return Card(
      child: Stack(
        children: <Widget>[
          Container(child: Image.asset('icons/colorful.png')),
          Container(
            alignment: Alignment.center,
            child: Text(
              'all',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
