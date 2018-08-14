import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:closet_app/item.dart';
import 'package:closet_app/select_color_page.dart';
import 'package:closet_app/select_typecategory_page.dart';

class Condition {
  String key;
  String operation;
  String value;

  Condition(String this.key, String this.operation, String this.value);
}

class ConditionsModel extends Model {
  final List<Condition> _conditions = new List();

  List<Condition> get conditions => _conditions;

  void add(Condition condition) {
    _conditions.add(condition);
    notifyListeners();
  }
}

class FilterPage extends StatefulWidget {
  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  String sql = """
               SELECT * FROM ${Item.tblItem}
               """;
  ConditionsModel conditionsModel = ConditionsModel();

  @override
  void initState() {
    conditionsModel._conditions.addAll([
      Condition("color", "=", "white"),
      Condition("typecategory", "=", "T-shits"),
   ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ConditionsModel>(
      model: conditionsModel,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Filter'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              ColorConditionRow(0),
              Divider(),
              TypeCategoryConditionRow(1),
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
                  Checkbox()
                ],
              ),
              Divider(),
            ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: (){
            if (conditionsModel.conditions != null) {
              sql += "WHERE "
                + conditionsModel.conditions.map((cond) =>
                    """
                    ${Item.tblItem}.${cond.key} = "${cond.value}"
                    """
                  ).toList().join(" AND ")
                +";";
            }
            print(sql);
            Navigator.pop(context, sql);
          },
        ),
      ),
    );
  }
}

class ColorConditionRow extends StatefulWidget {
  int index;

  ColorConditionRow(this.index);

  @override
  ColorConditionRowState createState() {
    return new ColorConditionRowState();
  }
}

class ColorConditionRowState extends State<ColorConditionRow> {
  Color _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConditionsModel>(
      builder: (context, _, model) {
        Condition condition = model.conditions[widget.index];
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
              child: Container(
                child: Card(
                  color: _color,
                ),
                width: 48.0,
                height: 48.0,
              ),
              onTap: (){
                Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new SelectColorPage()
                    )
                  ).then((color) {
                    condition.value = Color2Name[color];
                    setState(() {
                      _color = color;
                    });
                  });
              },
            ),
          ],
        );
      }
    );
  }
}

Map<Color, String> Color2Name = {
  Colors.black:      "black",
  Colors.white:      "white",
  Color(0xFF6E6D51):   "green",
  Color(0xFFC6B399):   "beige",
};

class TypeCategoryConditionRow extends StatefulWidget {
  int index;

  TypeCategoryConditionRow(this.index);

  @override
  TypeCategoryConditionRowState createState() {
    return new TypeCategoryConditionRowState();
  }
}

class TypeCategoryConditionRowState extends State<TypeCategoryConditionRow> {
  String _typecategory = "T-shits";

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConditionsModel>(
        builder: (context, _, model) {
          Condition condition = model.conditions[widget.index];
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
                  _typecategory,
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
                    condition.value = typecategory;
                    setState(() {
                      _typecategory = typecategory;
                    });
                  });
                },
              ),
            ],
          );
        }
    );
  }
}
