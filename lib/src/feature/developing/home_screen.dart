import 'package:flutter/material.dart';

import 'app_bar_widget.dart';
import 'carousel.dart';
import 'product_categories.dart';
import 'product_recommendation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            const AppBarWidget(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(18.0),
                child: TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ),
            ),
            const Carousel(),
            const ProductCategories(),
            const ProductRecommendation()
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
