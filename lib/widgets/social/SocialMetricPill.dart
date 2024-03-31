import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/objects/SocialMetric.dart';

class SocialMetricPill extends StatelessWidget {
  final SocialMetric socialMetric;

  const SocialMetricPill({
    required this.socialMetric,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SizedBox(width: 2),
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/socialIcons/${socialMetric.name}.png'),
          ),
          SizedBox(width: 5),
          Text('${socialMetric.value} ${socialMetric.unit}', style: kCaption1),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
