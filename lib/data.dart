import 'package:flutter/material.dart';
import 'dart:math';

class Item {
  String imageFile, category, color;

  Item(this.imageFile, this.category, this.color);
}

class Outfit {
  List<Item> items;

  Outfit(this.items);
}


List<Outfit> outfits = [
  Outfit([
    Item('./images/T_big_white.PNG',
         'T-shirt','white'),
    Item('./images/slucks_black.PNG',
         'slucks','black'),
    Item('./images/dress_shoes_black_martens.PNG',
         'dress shoes','black'),
  ]),
  Outfit([
    Item('./images/shirtshalf_aloha.PNG',
        'half sleeve shirts','grey'),
    Item('./images/denim_indigo.PNG',
        'denim pants','blue'),
    Item('./images/dress_shoes_black_martens.PNG',
        'dress shoes','black'),
    Item('./images/dress_shoes_black_martens.PNG',
        'dress shoes','black'),
    Item('./images/dress_shoes_black_martens.PNG',
        'dress shoes','black'),
  ]),
];

List<Item> items = outfits.expand(
  (outfit) => outfit.items
).toList();

List<Widget> itemImages = items.map(
  (item) => Image(image: AssetImage(item.imageFile)),
).toList();

List<Widget> outfitImages = outfits.map(
  (outfit) => GridView.count(
    primary: false,
    padding: const EdgeInsets.all(0.0),
    crossAxisSpacing: 10.0,
    crossAxisCount: sqrt(outfit.items.length).ceil(),
    children: outfit.items.map(
      (item) => Image(image: AssetImage(item.imageFile))
    ).toList(),
  )
).toList();