import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import 'promotions.dart';
import 'product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
  int _currentPage = 0;
  late CarouselSliderController _pageController;

  @override
  void initState() {
    super.initState();
    loadProducts();
    _pageController = CarouselSliderController();
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

  List<Widget> _buildPageIndicator() {
    return List.generate(items.length, (index) {
      return _indicator(index == _currentPage);
    });
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 4.0,
      width: 20,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  Widget buildPromotionsContainer(Promotions promotion) {
    return GestureDetector(
      onTap: () {
        debugPrint(promotion.title);
      },
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

  Widget _buildCategoryItem(String category, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4.4,
          height: MediaQuery.of(context).size.height / 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 32,
              ),
              const SizedBox(height: 8),
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
      _buildCategoryItem('Accessories', Icons.car_repair),
      _buildCategoryItem('Agro', Icons.grass),
      _buildCategoryItem('Food & Drinks', Icons.restaurant),
      _buildCategoryItem('Animals', Icons.pets),
      _buildCategoryItem('Art & Crafts', Icons.create),
      _buildCategoryItem('Babies', Icons.child_care),
      _buildCategoryItem('Beauty', Icons.face),
      _buildCategoryItem('Toys', Icons.toys),
      _buildCategoryItem('Footwear', Icons.shopping_bag),
      _buildCategoryItem('Vehicles', Icons.directions_car),
      _buildCategoryItem('Cameras', Icons.photo_camera),
      _buildCategoryItem('Home Decor', Icons.home),
      _buildCategoryItem('Phones', Icons.phone_android),
      _buildCategoryItem('Construction', Icons.build),
      _buildCategoryItem('Appliances', Icons.kitchen),
      _buildCategoryItem('Electronics', Icons.tv),
      _buildCategoryItem('Sports', Icons.sports_soccer),
      _buildCategoryItem('Tools', Icons.build_circle),
      _buildCategoryItem('Parties', Icons.cake),
      _buildCategoryItem('Games', Icons.videogame_asset),
      _buildCategoryItem('Commerce', Icons.store),
      _buildCategoryItem('Computers', Icons.computer),
      _buildCategoryItem('Tickets', Icons.event),
      _buildCategoryItem('Music', Icons.music_note),
      _buildCategoryItem('Jewelry', Icons.watch),
      _buildCategoryItem('Books', Icons.menu_book),
      _buildCategoryItem('Movies', Icons.movie),
      _buildCategoryItem('Health', Icons.favorite),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () {
                          debugPrint('Perfil');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person_outlined),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () {
                          debugPrint('Carrinho');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.shopping_cart_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 16),
              Container(
                height: size.height / 5,
                margin: const EdgeInsets.all(8),
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
                      padding: const EdgeInsets.only(bottom: 12, right: 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Product Categories',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
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
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Product Recommendations',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 5 * currentItemCount,
                      child: Column(
                        children: List.generate(
                          (currentItemCount ~/ 2),
                          (index) {
                            final int startIndex = index * 2;
                            return Row(
                              children: [
                                buildProductItem(products[startIndex]),
                                buildProductItem(products[startIndex + 1]),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
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
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
