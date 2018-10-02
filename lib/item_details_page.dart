import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/database.dart';
import 'package:closet_app/items_model.dart';


class ItemDetailsPage extends StatefulWidget {
  Item item;

  ItemDetailsPage(this.item);

  @override
  ItemDetailsPageState createState() {
    return new ItemDetailsPageState();
  }
}

class ItemDetailsPageState extends State<ItemDetailsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "${widget.item.color} ${widget.item.category}"
        ),
        //backgroundColor: Colors.black,
        //elevation: 0.0,
        //iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageRow(),
              SizedBox(height: 16.0),
              CategoryRow(),
              Divider(height: 10.0, color: Colors.black38),
              ColorRow(),
              Divider(height: 10.0, color: Colors.black38),
              OwnedRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget ImageRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Image.asset(
          join("images", widget.item.imageName),
          fit: BoxFit.cover,
        ),
      )
    );
  }

  Widget CategoryRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "category",
            style: const TextStyle(
              fontSize: 20.0,
              fontFamily: "CrimsonText",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        FlatButton(
            onPressed: () {
              
            },
            child: Text(
              widget.item.typeCategory,
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "CrimsonText",
                fontWeight: FontWeight.w400,
                color: Colors.blue,
              ),
            )
        )
      ],
    );
  }

  Widget ColorRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "color",
            style: const TextStyle(
              fontSize: 20.0,
              fontFamily: "CrimsonText",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        FlatButton(
          onPressed: () {},
          child: Text(
            widget.item.color,
            style: const TextStyle(
              fontSize: 20.0,
              fontFamily: "CrimsonText",
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          )
        )
      ],
    );
  }

  Widget OwnedRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Text(
            "owned",
            style: const TextStyle(
              fontSize: 20.0,
              fontFamily: "CrimsonText",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Checkbox(
          value: widget.item.owned,
          onChanged: (bool value) {
            setState(() {
              widget.item.owned = value;
            });
            ClosetDatabase.get().updateItem(widget.item);
          },
        ),
      ],
    );
  }
}

class IconButtonText extends StatelessWidget {
  final VoidCallback onClick;
  final IconData iconData;
  final String text;
  bool selected = false;
  final Color selectedColor = Color(0xff283593);

  IconButtonText({
    @required this.onClick,
    @required this.iconData,
    @required this.text,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onClick,
      child: Column(
        children: <Widget>[
          Icon(
            iconData,
            color: selected
              ? selectedColor
              : Colors.black
          ),
          Text(
            text,
            style: TextStyle(
              color: selected
                ? selectedColor
                : Colors.black
            ),
          )
        ],
      ),
    );
  }
}



