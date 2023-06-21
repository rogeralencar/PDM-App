import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
      title: 'Bem-vindo à nossa loja!',
      content:
          '\tSomos uma loja online especializada em vendas de produtos diversos. '
          'Oferecemos uma ampla variedade de itens, desde eletrônicos e móveis '
          'até roupas e acessórios. Com qualidade garantida e preços competitivos, '
          'temos o que você procura. Aproveite nossas promoções e faça suas compras '
          'com toda a comodidade!',
      image:
          'https://cdn.awsli.com.br/1101/1101329/produto/155685739/fc8ff2c15a.jpg',
    ),
    Promotion(
      title: 'Frete grátis em todos os pedidos!',
      content:
          '\tNa nossa loja, oferecemos frete grátis em todos os pedidos, sem valor mínimo de compra. '
          'Entregamos para todo o país com agilidade e segurança. Aproveite essa vantagem exclusiva '
          'e faça suas compras sem preocupações!',
      image:
          'https://ajuda.simplo7.com.br/hc/article_attachments/7681169045659/225edfb8a33c5a100cce5e21a13fe102.jpg',
    ),
    Promotion(
      title: 'Promoção de Inverno',
      content:
          '\tAproveite nossa promoção de inverno com descontos imperdíveis! '
          'Compre casacos, botas, cobertores e muito mais com preços incríveis. '
          'Mantenha-se aquecido e estiloso neste inverno com nossas ofertas especiais!',
      image:
          'https://static.vecteezy.com/system/resources/previews/013/553/618/original/winter-sale-promotion-banner-winter-special-offers-square-banner-social-media-post-advertising-winter-background-free-vector.jpg',
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
                  const Text(
                    'Show more',
                    style: TextStyle(
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
                child: Image.network(
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
