import 'package:flutter/material.dart';

import 'product_card.dart';

class ProductRecommendation extends StatefulWidget {
  const ProductRecommendation({super.key});

  @override
  State<ProductRecommendation> createState() => _ProductRecommendationState();
}

class _ProductRecommendationState extends State<ProductRecommendation> {
  List<String> products = [
    'celular',
    'camisa',
    'panela',
    'lenço',
    'geladeira',
    'skate',
    'ps5',
    'porshe',
    'paracetamol',
    'mouse',
    'fone de ouvido',
    'perfume',
  ];
  bool isLoading = false;
  int currentItemCount = 6;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        for (int i = 0; i < 6; i++) {
          products.add('Produto ${products.length + 1}');
        }
      });
    });
  }

  void loadMoreProducts() {
    // Simulando o carregamento de mais produtos
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        for (int i = 0; i < 6; i++) {
          products.add('Produto ${products.length + 1}');
        }
      });
    });
  }

  Widget buildProductItem(String product) {
    return ProductCard(
      imageUrl:
          'https://www.vejalimpeza.com.br/produtos/_jcr_content/root/lowerContentArea/table/header4.coreimg.png/1629750054912/imagem-produto-veja-limpeza-pesada-original-1l.png',
      name: product,
      price: 100.00,
      isFavorite: false,
      onFavoritePressed: () {},
    );
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
                'We Recommend',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  debugPrint('Ver todos os produtos');
                },
                child: const Text(
                  'See all',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: List.generate(
              (currentItemCount ~/ 2),
              (index) {
                final int startIndex = index * 2;
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      buildProductItem(products[startIndex]),
                      const SizedBox(width: 6),
                      buildProductItem(products[startIndex + 1]),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            child: const Text('Show More'),
            onPressed: () {
              setState(() {
                currentItemCount += 6;
              });
              loadMoreProducts();
            },
          ),
        ),
      ],
    );
  }
}
