import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
  );

  List<String> images = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    // Add more image paths
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: PageView.builder(
        controller: _controller,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return AspectRatio(
            aspectRatio: 16 /
                9, // Adjust this value according to your images' aspect ratio
            child: Container(
              color: Colors.red,
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
