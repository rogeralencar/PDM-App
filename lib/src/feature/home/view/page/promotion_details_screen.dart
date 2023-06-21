import 'package:flutter/material.dart';

import '../../repository/promotion.dart';

class PromotionDetailsScreen extends StatelessWidget {
  final Promotion promotion;

  const PromotionDetailsScreen({
    super.key,
    required this.promotion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snap'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              promotion.image,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              promotion.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              promotion.content,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
