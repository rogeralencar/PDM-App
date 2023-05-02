import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class OnBoardingDetailsScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isTitle;

  const OnBoardingDetailsScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isTitle,
  });

  @override
  State<OnBoardingDetailsScreen> createState() =>
      OnBoardingDetailsScreenState();
}

class OnBoardingDetailsScreenState extends State<OnBoardingDetailsScreen>
    with TickerProviderStateMixin {
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GifController controller = GifController(vsync: this);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        widget.isTitle
            ? const Text(
                'Snap',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            : Column(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
        Gif(
          image: AssetImage(widget.imagePath),
          controller: controller,
          autostart: Autostart.loop,
          duration: const Duration(seconds: 3),
          placeholder: (context) => const Text(
            'Loading...',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onFetchCompleted: () {
            controller.reset();
            controller.forward();
          },
          width: 340,
          height: 320,
          fit: BoxFit.cover,
        ),
        if (widget.isTitle)
          Column(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
