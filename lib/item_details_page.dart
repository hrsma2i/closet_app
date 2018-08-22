import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/database.dart';
import 'package:closet_app/items_model.dart';


class ItemDetailsPage extends StatelessWidget {
  int itemId;

  ItemDetailsPage(this.itemId);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, model) {
        if (model == null) {
          return Container();
        }
        Item item = model.items.firstWhere((it) =>
            it.itemId == itemId
        );
        return Scaffold(
          appBar: AppBar(
            title:  Text(
              "${item.color} ${item.category}"
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.asset(
                        join("images", item.imageName),
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  SizedBox(height: 16.0),
                  Row(
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
                        onPressed: () {},
                        child: Text(
                          item.category,
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
                  Divider(height: 10.0, color: Colors.black38),
                  Row(
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
                          item.color,
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
                  Divider(height: 10.0, color: Colors.black38),
                  Row(
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
                        value: item.owned,
                        onChanged: (bool value) {
                          item.owned = value;
                          //model.updateItem(item);
                          ClosetDatabase.get().updateItem(item);
                        },
                      ),
                    ],
                  ),
                  Divider(height: 10.0, color: Colors.black38),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButtonText(
                          onClick: () {},
                          iconData: Icons.store,
                          text: "Search store",
                          selected: false,
                        ),
                      ),
                      Expanded(
                        child: IconButtonText(
                          onClick: () {},
                          iconData: Icons.store,
                          text: "Search store",
                          selected: false,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 32.0, color: Colors.black38),
                  Text(
                    "Description",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: "CrimsonText",
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
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
      },
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



