import 'package:flutter/material.dart';

class SelectTypeCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select category"),
        automaticallyImplyLeading: false,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(2.5),
        crossAxisCount: 4,
        crossAxisSpacing: 2.5,
        children: [
          TypeCategoryCard("T-shirts"),
          TypeCategoryCard("polo"),
          TypeCategoryCard("shirts"),
          TypeCategoryCard("tops_open"),
          TypeCategoryCard("tops_pullover"),
          TypeCategoryCard("outer_short"),
          TypeCategoryCard("outer_long"),
          TypeCategoryCard("bottoms"),
          TypeCategoryCard("shoes"),
          TypeCategoryCard("other"),
        ],
      ),
    );
  }
}

class TypeCategoryCard extends StatelessWidget {
  String typecategory;

  TypeCategoryCard(this.typecategory);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraint){
                  return new Icon(
                    Icons.airline_seat_recline_normal,
                    size: constraint.biggest.height
                  );
                },
              ),
            ),
            Text(typecategory),
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).pop(typecategory);
      },
    );
  }
}
