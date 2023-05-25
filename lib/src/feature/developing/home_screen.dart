import 'package:flutter/material.dart';

import 'promotions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Promotions> items = [
    Promotions(
        title: 'Page 3',
        subTitle: 'Show More 3',
        image:
            'https://casaeconstrucao.org/wp-content/uploads/2022/07/2-modelo-de-frase-para-loja-de-roupas.png'),
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
    Promotions(
        title: 'Page 1',
        subTitle: 'Show More 1',
        image:
            'https://casaeconstrucao.org/wp-content/uploads/2022/07/2-modelo-de-frase-para-loja-de-roupas.png'),
  ];
  int _currentPage = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    if (_pageController.page! > items.length - 1.01) {
      _pageController.jumpToPage(1);
    } else if (_pageController.page! < 0.01) {
      _pageController.jumpToPage(items.length - 2);
    }

    setState(() {
      _currentPage = _pageController.page!.toInt();
    });
  }

  void _scrollToNext() {
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _scrollToPrevious() {
    _pageController.animateToPage(
      _currentPage - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  List<Widget> _buildPageIndicator() {
    return List.generate(items.length - 2, (index) {
      return _indicator(index == _currentPage - 1);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
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
      _buildCategoryItem('Instruments', Icons.music_note),
      _buildCategoryItem('Jewelry', Icons.watch),
      _buildCategoryItem('Books', Icons.menu_book),
      _buildCategoryItem('Music', Icons.music_note),
      _buildCategoryItem('Health', Icons.favorite),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                child: Row(
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
              Material(
                elevation: 4,
                child: Container(
                  height: size.height / 5,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final promotions = items[index];
                      return buildPromotionsContainer(promotions);
                    },
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
              // Add your product recommendation widgets here
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
