import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class CircleAvatarWBorder extends StatelessWidget {
  final String image;
  final double radius;

  const CircleAvatarWBorder({
    required this.image,
    this.radius = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + 1,
      backgroundColor: kPrimaryColour20,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(image),
      ),
    );
  }
}
