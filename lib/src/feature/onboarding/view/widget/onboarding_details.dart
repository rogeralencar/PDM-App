import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class OnBoardingDetails extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isTitle;

  const OnBoardingDetails({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isTitle,
  });

  @override
  State<OnBoardingDetails> createState() => OnBoardingDetailsState();
}

class OnBoardingDetailsState extends State<OnBoardingDetails>
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

  void loadGifs() {}

  @override
  Widget build(BuildContext context) {
    GifController controller = GifController(vsync: this);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        widget.isTitle
            ? Text(
                'Snap',
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              )
            : Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.tertiary,
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
          placeholder: (context) => CircularProgressIndicator(
            color: Theme.of(context).colorScheme.outline,
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.background,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
