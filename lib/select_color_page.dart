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
            colorColumn(["black", "grey", "white"]),
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

  Widget colorColumn(List<String> colorNames) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: colorNames.map((name) => ColorCard(name)).toList(),
      ),
    );
  }
}

class ColorCard extends StatelessWidget {
  String colorName;

  ColorCard(this.colorName);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        child: Card(
          color: name2color[colorName],
        ),
        onTap: (){
          Navigator.of(context).pop(colorName);
        },
      ),
    );
  }
}
