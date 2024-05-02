import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class CircleAvatarWBorder extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Color borderColor;

  const CircleAvatarWBorder({
    required this.imageUrl,
    this.radius = 10,
    this.borderColor = kPrimaryColour20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + 1,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
