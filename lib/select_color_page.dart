import 'package:flutter/material.dart';

class SelectColorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select category"),
        automaticallyImplyLeading: false,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(2.5),
        crossAxisCount: 5,
        crossAxisSpacing: 2.5,
        children: [
          ColorCard(Colors.black),
          ColorCard(Colors.white),
          ColorCard(Color(0xFF6E6D51)),
          ColorCard(Color(0xFFC6B399)),
        ],
      ),
    );
  }
}

class ColorCard extends StatelessWidget {
  Color color;

  ColorCard(this.color);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
        color: color,
      ),
      onTap: (){
        Navigator.of(context).pop(color);
      },
    );
  }
}
