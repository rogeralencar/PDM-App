import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/view/widget/auth.dart';
import '../widget/onboarding_details.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final Auth auth = Modular.get<Auth>();
  int _currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = const [
    OnBoardingDetails(
      title: 'Bem-vindo a loja Snap',
      subtitle: 'A melhor loja virtual que você vai conhecer!',
      imagePath: 'lib/assets/images/snap_LOGO_GIF.gif',
      isTitle: true,
    ),
    OnBoardingDetails(
      title: 'Tenha um app feito para você',
      subtitle:
          'Aqui no snap você tem variás opções para compras, onde uma dessas opções pode até ser sua!',
      imagePath: 'lib/assets/images/snap_CARRINHO_GIF.gif',
      isTitle: false,
    ),
    OnBoardingDetails(
      title: 'Começe agora!',
      subtitle:
          'Crie seu perfil e comece a fazer suas compras ou vendas, o aplicativo snap é todo feito para e pelos nossos usuários',
      imagePath: 'lib/assets/images/snap_MAO.SELL.BUY_GIF.gif',
      isTitle: false,
    ),
  ];

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 16.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> checkOnboardingStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (onboardingCompleted) {
      if (auth.isAuth) {
        Modular.to.pushReplacementNamed('/home/');
      } else {
        Modular.to.pushReplacementNamed('/auth/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 20,
                    ),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  _currentPage != 2
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 20,
                          ),
                          onPressed: () {
                            Modular.to.pushNamed('/auth/');
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        )
                      : const Text(''),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 20,
                    ),
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      } else {
                        Modular.to.pushNamed('/auth/');
                      }
                    },
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Done' : 'Next',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
