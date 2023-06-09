import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/constants.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}

class Product with ChangeNotifier {
  bool isFavorite;
  final int orders;
  final List<String> category;
  final String description;
  final String id;
  final dynamic image;
  final PlaceLocation location;
  final String name;
  final double price;
  final String userId;

  Product({
    this.isFavorite = false,
    this.orders = 0,
    required this.category,
    required this.description,
    required this.id,
    required this.image,
    required this.location,
    required this.name,
    required this.price,
    required this.userId,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      _toggleFavorite();

      final response = await http.put(
        Uri.parse(
          '${Constants.userFavoritesUrl}/$userId/$id.json?auth=$token',
        ),
        body: jsonEncode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}
