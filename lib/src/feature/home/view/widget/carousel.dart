import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

import '../../repository/promotion.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late CarouselSliderController _pageController;

  final List<Promotion> items = [
    Promotion(
      title: 'promotion_title1'.i18n(),
      content: 'promotion_content1'.i18n(),
      image: 'lib/assets/images/welcome.png',
    ),
    Promotion(
      title: 'promotion_title2'.i18n(),
      content: 'promotion_content2'.i18n(),
      image: 'lib/assets/images/free_shipping.png',
    ),
    Promotion(
      title: 'promotion_title3'.i18n(),
      content: 'promotion_content3'.i18n(),
      image: 'lib/assets/images/winter_sale.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = CarouselSliderController();
  }

  Widget buildPromotionsContainer(Promotion promotion) {
    return ElevatedButton(
      onPressed: () {
        Modular.to.pushNamed('promotionDetails', arguments: promotion);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    promotion.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'show_more'.i18n(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  promotion.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.18,
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
          slideTransform: const DepthTransform(),
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
