import 'package:flutter/material.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  Widget _buildCategoryItem(String category, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () {
          debugPrint(category);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryList() {
    return [
      _buildCategoryItem('Accessories', Icons.wallet_giftcard),
      _buildCategoryItem('Agro', Icons.grass),
      _buildCategoryItem('Animals', Icons.pets),
      _buildCategoryItem('Appliances', Icons.kitchen),
      _buildCategoryItem('Art & Crafts', Icons.create),
      _buildCategoryItem('Babies', Icons.child_care),
      _buildCategoryItem('Beauty', Icons.face),
      _buildCategoryItem('Books', Icons.menu_book),
      _buildCategoryItem('Cameras', Icons.photo_camera),
      _buildCategoryItem('Clothes', Icons.style),
      _buildCategoryItem('Commerce', Icons.store),
      _buildCategoryItem('Computers', Icons.computer),
      _buildCategoryItem('Construction', Icons.build),
      _buildCategoryItem('Electronics', Icons.tv),
      _buildCategoryItem('Food & Drinks', Icons.restaurant),
      _buildCategoryItem('Footwear', Icons.shopping_bag),
      _buildCategoryItem('Games', Icons.videogame_asset),
      _buildCategoryItem('Health', Icons.favorite),
      _buildCategoryItem('Home Decor', Icons.home),
      _buildCategoryItem('Jewelry', Icons.watch),
      _buildCategoryItem('Music', Icons.music_note),
      _buildCategoryItem('Parties', Icons.cake),
      _buildCategoryItem('Phones', Icons.phone_android),
      _buildCategoryItem('Sports', Icons.sports_soccer),
      _buildCategoryItem('Tickets', Icons.event),
      _buildCategoryItem('Tools', Icons.build_circle),
      _buildCategoryItem('Toys', Icons.toys),
      _buildCategoryItem('Vehicles', Icons.directions_car),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  debugPrint('Ver todas as categorias');
                },
                child: Text(
                  'See all',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _buildCategoryList().length ~/ 2,
              itemBuilder: (BuildContext context, int index) {
                int itemIndex = index * 2;
                return Column(
                  children: [
                    _buildCategoryList()[itemIndex],
                    const SizedBox(width: 16),
                    if (itemIndex + 1 < _buildCategoryList().length)
                      _buildCategoryList()[itemIndex + 1],
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
