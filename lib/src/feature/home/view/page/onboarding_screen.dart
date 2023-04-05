import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:localization/localization.dart';

import 'onboarding_details.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  int _currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = [
    OnBoardingDetails(
        title: 'Onboard_title1'.i18n(),
        subtitle: 'Onboard_sub_title1'.i18n(),
        image: Image.asset('lib/assets/images/onboarding1.png')),
    OnBoardingDetails(
        title: 'Onboard_title2'.i18n(),
        subtitle: 'Onboard_sub_title2'.i18n(),
        image: Image.asset('lib/assets/images/onboarding2.jpeg')),
    OnBoardingDetails(
        title: 'Onboard_title3'.i18n(),
        subtitle: 'Onboard_sub_title3'.i18n(),
        image: Image.asset('lib/assets/images/onboarding3.png')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 162, 241, 255),
              Color.fromARGB(255, 20, 84, 109),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: Text(
                      'Back'.i18n(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _currentPage != 2
                      ? TextButton(
                          onPressed: () {
                            Modular.to.pushNamed('/form');
                          },
                          child: Text(
                            'Skip'.i18n(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Text(''),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      } else {
                        Modular.to.pushNamed('/form');
                      }
                    },
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Done'.i18n()
                          : 'Next'.i18n(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
