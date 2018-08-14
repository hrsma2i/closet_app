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
      Condition("typecategory", "=", "outer"),
      Condition("color",        "=", "black"),
      Condition("owned",        "=", "0"),
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
        body: Column(
          children: conditionsModel._conditions != null
            ? List.generate(
              conditionsModel.conditions.length,
              (index) {
                return ConditionRow(index);
              },
            )
            : new Container(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: (){
            if (conditionsModel._conditions != null) {
              sql += "WHERE "
                + conditionsModel._conditions.map((cond) =>
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

class ConditionRow extends StatefulWidget {
  int index;

  ConditionRow(this.index);

  @override
  ConditionRowState createState() {
    return new ConditionRowState();
  }
}

class ConditionRowState extends State<ConditionRow> {
  String selectedKey = "color";
  var selectedValue = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConditionsModel>(
      builder: (context, _, model) {
        Condition condition = model.conditions[widget.index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            DropdownButton(
              hint: Text((){
                selectedKey = condition.key;
                return selectedKey;
              }()),
              items: <String>[
                  Item.colTypeCategory,
                  Item.colColor,
                  Item.colOwned,
                ].map((String value) =>
                  new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  )
                ).toList(),
              onChanged: (key) {
                condition.key = key;
                setState(() {
                  selectedKey = key;
                });
              }
            ),
            (){
              setState(() {
                selectedValue = condition.value;
              });
              if (condition.key == "color") {
                return GestureDetector(
                  child: Container(
                    child: Card(
                      color: selectedValue,
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
                    )
                        .then((color) {
                      condition.value = Color2Name[color];
                      setState(() {
                        selectedValue = color;
                      });
                    });
                  },
                );
              } else  if (condition.key == "typecategory") {
                return GestureDetector(
                  child: Container(
                    child: Card(
                      child: Text(selectedValue),
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
                    )
                        .then((color) {
                      condition.value = Color2Name[color];
                      setState(() {
                        selectedValue = color;
                      });
                    });
                  },
                );
              } else {
                return new Container();
              }
            }(),
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