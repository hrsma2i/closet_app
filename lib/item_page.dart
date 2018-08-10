import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/database.dart';

class ItemPage extends StatefulWidget {
  final Item item;

  ItemPage(this.item);

  @override
  State<StatefulWidget> createState() => new ItemPageState();
}

class ItemPageState extends State<ItemPage> {

  GlobalKey<ScaffoldState> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
            "${widget.item.color} ${widget.item.category}"
        ),
        //backgroundColor: Colors.black,
        //elevation: 0.0,
        //iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new SingleChildScrollView(
        child: new Padding(
          padding: const EdgeInsets.all(32.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Center(
                  child: new Hero(
                    tag: "item_{$widget.item.itemId}",
                    child: new Image.asset(
                      join("images", widget.item.imageName),
                      fit: BoxFit.cover,
                    )
                  ),
                )
              ),
              new SizedBox(height: 16.0),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      "category",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: "CrimsonText",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  new FlatButton(
                      onPressed: (){},
                      child: Text(
                        widget.item.category,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: "CrimsonText",
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      )
                  )
                ],
              ),
              new Divider(height: 10.0, color: Colors.black38),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      "color",
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: "CrimsonText",
                          fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  new FlatButton(
                    onPressed: (){},
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
              ),
              new Divider(height: 10.0, color: Colors.black38),
              new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      "owned",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: "CrimsonText",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  new IconButton(
                    icon: Icon(
                      widget.item.owned
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    ),
                    onPressed: (){
                      setState(() {
                        widget.item.owned = !widget.item.owned;
                      });
                      ClosetDatabase.get().updateItem(widget.item);
                    },
                  ),
                ],
              ),
              new Divider(height: 10.0, color: Colors.black38),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new IconButtonText(
                      onClick: (){},
                      iconData: Icons.store,
                      text: "Search store",
                      selected: false,
                    ),
                  ),
                  new Expanded(
                    child: new IconButtonText(
                      onClick: (){
                        print("The id is: ${widget.item.itemId}");
                        Clipboard.setData(
                          new ClipboardData(
                            text: widget.item.itemId.toString()
                          )
                        );
                        key.currentState.showSnackBar(
                          new SnackBar(
                            content: new Text(
                              "Copied: \"${widget.item.itemId}\" to clipboard"
                            ),
                          )
                        );
                      },
                      iconData: Icons.bookmark,
                      text: "Bookmark",
                      selected: false,
                    ),
                  ),
                  new Expanded(
                    child: new IconButtonText(
                      onClick: (){
                        setState(() {
                          widget.item.owned = !widget.item.owned;
                        });
                      },
                      iconData: Icons.store,
                      text: "Search store",
                      selected: false,
                    ),
                  ),
                ],
              ),
              new Divider(height: 32.0, color: Colors.black38),
              new Text(
                "Description",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: "CrimsonText",
                ),
              ),
              new SizedBox(height: 8.0),
              new Text(
                "Description will be here.",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconButtonText extends StatelessWidget {
  final VoidCallback onClick;
  final IconData iconData;
  final String text;
  bool selected = false;
  final Color selectedColor = new Color(0xff283593);

  IconButtonText({
    @required this.onClick,
    @required this.iconData,
    @required this.text,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      onTap: onClick,
      child: new Column(
        children: <Widget>[
          new Icon(
            iconData,
            color: selected
              ? selectedColor
              : Colors.black
          ),
          new Text(
            text,
            style: new TextStyle(
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



