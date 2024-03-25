import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/CircleAvatarWBorder.dart';

class AvatarStack extends StatelessWidget {
  final List<String> images;
  final double radius;
  final int maxImages = 2;

  const AvatarStack({
    this.images = const [
      'assets/goodnotes_profile.jpeg',
      'assets/figma_profile.png',
    ],
    this.radius = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (var i = 0; i < maxImages && i < images.length; i++)
          Positioned(
            left: radius * 1.5 * i,
            child: CircleAvatarWBorder(
              image: images[i],
              radius: radius,
            ),
          ),
      ],
    );
  }
}
