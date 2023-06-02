import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../../repository/promotions.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late CarouselSliderController _pageController;

  final List<Promotions> items = [
    Promotions(
        title: 'Page 1',
        subTitle: 'Show More 1',
        image:
            'https://casaeconstrucao.org/wp-content/uploads/2022/07/2-modelo-de-frase-para-loja-de-roupas.png'),
    Promotions(
        title: 'Page 2',
        subTitle: 'Show More 2',
        image:
            'https://casaeconstrucao.org/wp-content/uploads/2022/07/2-modelo-de-frase-para-loja-de-roupas.png'),
    Promotions(
        title: 'Page 3',
        subTitle: 'Show More 3',
        image:
            'https://casaeconstrucao.org/wp-content/uploads/2022/07/2-modelo-de-frase-para-loja-de-roupas.png'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = CarouselSliderController();
  }

  Widget buildPromotionsContainer(Promotions promotion) {
    return ElevatedButton(
      onPressed: () {
        debugPrint(promotion.title);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  promotion.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  promotion.subTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                promotion.image,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: CarouselSlider.builder(
          controller: _pageController,
          unlimitedMode: true,
          itemCount: items.length,
          slideBuilder: (index) {
            final promotions = items[index];
            return buildPromotionsContainer(promotions);
          },
          enableAutoSlider: true,
          slideTransform: const CubeTransform(),
          slideIndicator: CircularWaveSlideIndicator(
            itemSpacing: 16,
            indicatorRadius: 4,
            padding: const EdgeInsets.only(bottom: 12, right: 36),
          ),
        ),
      ),
    );
  }
}
