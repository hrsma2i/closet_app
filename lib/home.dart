import 'package:closet_app/data.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: .5,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: (){},
      ),
      title: Text("All Items"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){},
        )
      ],
    );

    createTile(Item item) => Hero(
        tag: item.category,
        child: Material(
            elevation: 15.0,
            shadowColor: Colors.white,
            child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'detail/${item.category}');
                },
                child: Image(
                  image: AssetImage(item.image),
                  fit: BoxFit.cover,
                )
            )
        )
    );
    
    final grid = CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverGrid.count(
            childAspectRatio: 1.0,
            crossAxisCount: 4,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
            children: items.map((item) => createTile(item)).toList(),
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar,
      body: grid,
    );
  }

}