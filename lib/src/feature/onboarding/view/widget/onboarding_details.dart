import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gif/gif.dart';
import 'package:localization/localization.dart';

class OnBoardingDetails extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isTitle;

  const OnBoardingDetails({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isTitle,
  }) : super(key: key);

  @override
  State<OnBoardingDetails> createState() => OnBoardingDetailsState();
}

class OnBoardingDetailsState extends State<OnBoardingDetails>
    with TickerProviderStateMixin {
  late GifController _controller;
  late Future<void> _gifLoadingFuture;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
    _gifLoadingFuture = loadGif(widget.imagePath);
  }

  Future<void> loadGif(String gifPath) async {
    await precacheImage(CachedNetworkImageProvider(gifPath), context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.06),
        widget.isTitle
            ? Text(
                'Snap',
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              )
            : Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
        FutureBuilder<void>(
          future: _gifLoadingFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Theme.of(context).colorScheme.outline,
              );
            } else if (snapshot.hasError) {
              return Text('gif_error'.i18n());
            } else {
              return Gif(
                image: CachedNetworkImageProvider(widget.imagePath),
                controller: _controller,
                autostart: Autostart.loop,
                duration: const Duration(seconds: 3),
                placeholder: (context) => CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.outline,
                ),
                onFetchCompleted: () {
                  _controller.reset();
                  _controller.forward();
                },
                width: screenWidth * 0.9,
                height: screenHeight * 0.4,
                fit: BoxFit.cover,
              );
            }
          },
        ),
        if (widget.isTitle)
          Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
