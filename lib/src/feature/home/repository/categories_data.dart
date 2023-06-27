import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData iconData;

  Category({required this.name, required this.iconData});
}

List<Category> categoryList = [
  Category(name: 'Accessories', iconData: Icons.wallet_giftcard),
  Category(name: 'Agro', iconData: Icons.grass),
  Category(name: 'Animals', iconData: Icons.pets),
  Category(name: 'Appliances', iconData: Icons.kitchen),
  Category(name: 'Art & Crafts', iconData: Icons.create),
  Category(name: 'Babies', iconData: Icons.child_care),
  Category(name: 'Beauty', iconData: Icons.face),
  Category(name: 'Books', iconData: Icons.menu_book),
  Category(name: 'Cameras', iconData: Icons.photo_camera),
  Category(name: 'Clothes', iconData: Icons.style),
  Category(name: 'Commerce', iconData: Icons.store),
  Category(name: 'Computers', iconData: Icons.computer),
  Category(name: 'Construction', iconData: Icons.build),
  Category(name: 'Electronics', iconData: Icons.tv),
  Category(name: 'Food & Drinks', iconData: Icons.restaurant),
  Category(name: 'Footwear', iconData: Icons.shopping_bag),
  Category(name: 'Games', iconData: Icons.videogame_asset),
  Category(name: 'Health', iconData: Icons.favorite),
  Category(name: 'Home Decor', iconData: Icons.home),
  Category(name: 'Jewelry', iconData: Icons.watch),
  Category(name: 'Music', iconData: Icons.music_note),
  Category(name: 'Parties', iconData: Icons.cake),
  Category(name: 'Phones', iconData: Icons.phone_android),
  Category(name: 'Sports', iconData: Icons.sports_soccer),
  Category(name: 'Tickets', iconData: Icons.event),
  Category(name: 'Tools', iconData: Icons.build_circle),
  Category(name: 'Toys', iconData: Icons.toys),
  Category(name: 'Vehicles', iconData: Icons.directions_car),
];
