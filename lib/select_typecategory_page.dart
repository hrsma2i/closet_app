import 'package:flutter/material.dart';
import 'typecategory.dart';

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
        children: name2image.keys.map((typeCategory) =>
            TypeCategoryCard(typeCategory)
        ).toList(),
      ),
    );
  }
}

class TypeCategoryCard extends StatelessWidget {
  String typeCategory;

  TypeCategoryCard(this.typeCategory);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: GridTile(
        footer: AspectRatio(
          aspectRatio: 2.5,
          child: GridTileBar(
            backgroundColor: Colors.black54,
            title: Container(
              alignment: Alignment.center,
              child: Text(
                typeCategory.replaceAll('_', '\n'),
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ),
          ),
        ),
        child: name2image[typeCategory],
      ),
      onTap: (){
        Navigator.of(context).pop(typeCategory);
      },
    );
  }
}
