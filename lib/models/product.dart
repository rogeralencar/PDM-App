import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final String id;
  final String name;
  final String description;
  final double price;
  final dynamic image;
  final PlaceLocation location;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.location = const PlaceLocation(
      latitude: -15.793889,
      longitude: -47.882778,
      address: "Brasília, DF",
    ),
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
