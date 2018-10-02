import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/select_color_page.dart';
import 'package:closet_app/select_typecategory_page.dart';
import 'package:closet_app/color.dart';

class Condition {
  String key;
  String operation;
  String value;

  Condition(String this.key, String this.operation, String this.value);
}

class ConditionModel extends Model {
  String colorName;
  String typecategory;
  bool owned;

  ConditionModel(this.colorName, this.typecategory, this.owned);

  String getSql() {
    String sql = """
                 SELECT * FROM ${Item.tblItem}
                 """;

    List<String> sqlParts = new List();

    if ((colorName != null)
        || (typecategory != null)
        || (owned != null)) {
      sql += "WHERE ";
    }
    if (colorName != null) {
      sqlParts.add("""
        ${Item.tblItem}.${Item.colColor} = "$colorName"
      """);
    }
    if (typecategory != null) {
      sqlParts.add("""
        ${Item.tblItem}.${Item.colTypeCategory} = "$typecategory"
      """);
    }
    if (owned != null) {
      sqlParts.add("""
        ${Item.tblItem}.${Item.colOwned} = ${owned?1:0}
      """);
    }
    sql += sqlParts.join("AND") + ";";

    return sql;
  }
}

class FilterPage extends StatefulWidget {
  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  ConditionModel condition = ConditionModel(
    null,
    null,
    null,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ConditionModel>(
      model: condition,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Filter'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              ColorConditionRow(),
              Divider(),
              TypeCategoryConditionRow(),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "owned",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    )
                  ),
                  Checkbox(
                    tristate: true,
                    value: condition.owned,
                    onChanged: (bool value) {
                      setState(() {
                        condition.owned = value;
                      });
                    }
                  )
                ],
              ),
              Divider(),
            ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: (){
            String sql = condition.getSql();
            print(sql);
            Navigator.pop(context, sql);
          },
        ),
      ),
    );
  }
}

class ColorConditionRow extends StatefulWidget {

  ColorConditionRow();

  @override
  ColorConditionRowState createState() {
    return new ColorConditionRowState();
  }
}

class ColorConditionRowState extends State<ColorConditionRow> {
  //Color _color = null;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConditionModel>(
      builder: (context, _, condition) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "color",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20.0
                ),
              )
            ),
            GestureDetector(
              child: condition.colorName != null
                ? Container(
                  child: Card(
                    color: name2color[condition.colorName],
                  ),
                  width: 48.0,
                  height: 48.0,
                )
                : Text(
                  "all",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
              onTap: (){
                Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new SelectColorPage()
                    )
                  ).then((colorName) {
                    print(colorName);
                    condition.colorName = colorName;
                    print(condition.colorName);
                    //setState(() {
                    //  _color = color;
                    //});
                  });
              },
            ),
          ],
        );
      }
    );
  }
}


class TypeCategoryConditionRow extends StatefulWidget {

  TypeCategoryConditionRow();

  @override
  TypeCategoryConditionRowState createState() {
    return new TypeCategoryConditionRowState();
  }
}

class TypeCategoryConditionRowState extends State<TypeCategoryConditionRow> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConditionModel>(
        builder: (context, _, model) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  "typecategory",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                )
              ),
              FlatButton(
                child: Text(
                  model.typecategory != null
                    ? model.typecategory
                    : "all",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new SelectTypeCategoryPage()
                    )
                  ).then((typecategory) {
                    model.typecategory = typecategory;
                  });
                },
              ),
            ],
          );
        }
    );
  }
}
