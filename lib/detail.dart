import 'database.dart';
import 'rating_bar.dart';
import 'package:flutter/material.dart';

//class Detail extends StatelessWidget {
//  final Item item;
//
//  Detail(this.item);
//
//  @override
//  Widget build(BuildContext context) {
//    final appBar = AppBar(
//      elevation: .5,
//      title: Text('All Items'),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.search),
//          onPressed: () {},
//        )
//      ],
//    );
//
//    final topLeft = Column(
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.all(16.0),
//          child: Hero(
//            tag: item.category,
//            child: Material(
//              elevation: 15.0,
//              shadowColor: Colors.white,
//              child: Image(
//                image: AssetImage(item.image),
//                fit: BoxFit.cover,
//              ),
//            ),
//          )
//        ),
//        text(
//          'category: ${item.category}',
//          color: Colors.white,
//          size: 12,
//        ),
//      ],
//    );
//
//    final topRight = Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        text(
//          item.category,
//          size:16,
//          isBold: true,
//          padding: EdgeInsets.only(top: 16.0),
//        ),
//        text(
//          'color: ${item.color}',
//          color: Colors.white,
//          size: 12,
//          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
//        ),
//        Row(
//          children: <Widget>[
//            text(
//              item.color,
//              isBold: true,
//              padding: EdgeInsets.only(right: 8.0),
//            ),
//          ],
//        ),
//        SizedBox(height: 32.0),
//        Material(
//          borderRadius: BorderRadius.circular(28.0),
//          shadowColor: Colors.blue.shade200,
//          elevation: 5.0,
//          child: MaterialButton(
//            onPressed: (){},
//            color: Colors.blue,
//            child: text('BUY NOW', color:Colors.white),
//          ),
//        )
//      ],
//    );
//
//    final bottomContent = Container(
//      height: 300.0,
//      child: SingleChildScrollView(
//        padding: EdgeInsets.all(16.0),
//        child: Text(
//          item.category,
//          style: TextStyle(fontSize: 13.0),
//        ),
//      ),
//    );
//
//    final topContent = Container(
//      color: Theme.of(context).primaryColor,
//      padding: EdgeInsets.only(bottom: 16.0),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Flexible(flex: 2, child: topLeft),
//          Flexible(flex: 3, child: topRight),
//        ],
//      )
//    );
//
//    return new Scaffold(
//      appBar: appBar,
//      body: Column(
//        children: <Widget>[
//          topContent,
//          bottomContent,
//        ],
//      ),
//    );
//  }
//
//  text(String data,
//        {Color color = Colors.white,
//        num size = 14,
//        EdgeInsetsGeometry padding = EdgeInsets.zero,
//        bool isBold = false}) =>
//      Padding(
//        padding: padding,
//        child: Text(data,
//          style: TextStyle(
//            color:  color,
//            fontSize: size.toDouble(),
//            fontWeight: isBold
//              ? FontWeight.bold
//              : FontWeight.normal
//          ),
//        ),
//      );
//}