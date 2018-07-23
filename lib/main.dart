import 'package:flutter/material.dart';

import 'package:closet_app/home.dart';

void main() => runApp(new MyApp());

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Closet App',
//      debugShowCheckedModeBanner: false,
//      theme: new ThemeData.dark(),
//      home: Home(),
//      onGenerateRoute: (settings) => generateRoute(settings),
//    );
//  }
//
//  generateRoute(RouteSettings settings) {
//    final path = settings.name.split('/');
//    final category = path[1];
//
//    Item item = items.firstWhere((it) => it.category == category);
//    return MaterialPageRoute(
//      settings: settings,
//      builder: (context) => Detail(item),
//    );
//  }
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeScreen()
    );
  }
}
