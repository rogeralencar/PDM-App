import 'dart:io';

import 'package:flutter/material.dart';

import '../../repository/product.dart';
import 'map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product place = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.file(
              place.image as File,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.map),
            label: const Text('Ver no Mapa'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => const MapScreen(
                    isReadOnly: true,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
