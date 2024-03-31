import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  List<String> images = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    // Add more image paths
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (var image in images) ...[
          Container(
            height: 200,
            width: 200,
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        ],
      ],
    );
  }
}
