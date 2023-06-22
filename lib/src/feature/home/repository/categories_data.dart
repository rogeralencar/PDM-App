import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Category {
  final String name;
  final IconData iconData;

  Category({required this.name, required this.iconData});
}

List<Category> categoryList = [
  Category(name: 'accessories'.i18n(), iconData: Icons.wallet_giftcard),
  Category(name: 'agro'.i18n(), iconData: Icons.grass),
  Category(name: 'animals'.i18n(), iconData: Icons.pets),
  Category(name: 'appliances'.i18n(), iconData: Icons.kitchen),
  Category(name: 'art_&_crafts'.i18n(), iconData: Icons.create),
  Category(name: 'babies'.i18n(), iconData: Icons.child_care),
  Category(name: 'beauty'.i18n(), iconData: Icons.face),
  Category(name: 'books'.i18n(), iconData: Icons.menu_book),
  Category(name: 'cameras'.i18n(), iconData: Icons.photo_camera),
  Category(name: 'clothes'.i18n(), iconData: Icons.style),
  Category(name: 'commerce'.i18n(), iconData: Icons.store),
  Category(name: 'computers'.i18n(), iconData: Icons.computer),
  Category(name: 'construction'.i18n(), iconData: Icons.build),
  Category(name: 'electronics'.i18n(), iconData: Icons.tv),
  Category(name: 'food_&_drinks'.i18n(), iconData: Icons.restaurant),
  Category(name: 'footwear'.i18n(), iconData: Icons.shopping_bag),
  Category(name: 'games'.i18n(), iconData: Icons.videogame_asset),
  Category(name: 'health'.i18n(), iconData: Icons.favorite),
  Category(name: 'home Decor'.i18n(), iconData: Icons.home),
  Category(name: 'jewelry'.i18n(), iconData: Icons.watch),
  Category(name: 'music'.i18n(), iconData: Icons.music_note),
  Category(name: 'parties'.i18n(), iconData: Icons.cake),
  Category(name: 'phones'.i18n(), iconData: Icons.phone_android),
  Category(name: 'sports'.i18n(), iconData: Icons.sports_soccer),
  Category(name: 'tickets'.i18n(), iconData: Icons.event),
  Category(name: 'tools'.i18n(), iconData: Icons.build_circle),
  Category(name: 'toys'.i18n(), iconData: Icons.toys),
  Category(name: 'vehicles'.i18n(), iconData: Icons.directions_car),
];
